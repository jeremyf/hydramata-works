require 'hydramata/work/datastream_parser'

module Hydramata
  module Work
    class FedoraWrangler
      attr_reader :repo, :entity
      def initialize(collaborators = {})
        @repo = collaborators.fetch(:repository_connection) { default_repository_connection }
        @entity = collaborators.fetch(:entity)
      end

      def call(pid, options = {})
        with_datastreams = options.fetch(:with_datastreams, false)
        object = @repo.find(pid)
        assign_work_type_from(object)
        parse_datastreams(object) if with_datastreams
      end

      private

      def default_repository_connection
        require 'rubydora'
        # Please note: these parameters were used in building the VCR cassettes, so please don't change them.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
      end

      def assign_work_type_from(object)
        object.profile['objModels'].each do |model|
          if model =~ /\Ainfo:fedora\/afmodel\:(.*)\Z/
            entity.work_type = Regexp.last_match[1]
            break
          end
        end
      end

      def parse_datastreams(object)
        object.datastreams.each do |_name, datastream|
          parse_datastream_content(datastream)
        end
      end

      def parse_datastream_content(datastream)
        DatastreamParser.call(datastream: datastream, entity: entity) do |property|
          entity.properties << property
        end
      end
    end
  end
end
