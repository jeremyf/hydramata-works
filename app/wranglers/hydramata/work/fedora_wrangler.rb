module Hydramata
  module Work
    class FedoraWrangler
      attr_reader :repository_connection, :entity, :datastream_parser
      def initialize(collaborators = {})
        @repository_connection = collaborators.fetch(:repository_connection) { default_repository_connection }
        @datastream_parser = collaborators.fetch(:datastream_parser) { default_datastream_parser }
        @entity = collaborators.fetch(:entity)
      end

      def call(pid, options = {})
        with_datastreams = options.fetch(:with_datastreams) { default_with_datastreams }
        object = repository_connection.find(pid)
        assign_work_type_from(object)
        parse_datastreams(object) if with_datastreams
      end

      private

      def default_datastream_parser
        require 'hydramata/work/datastream_parser'
        DatastreamParser
      end

      def default_with_datastreams
        false
      end

      def default_repository_connection
        require 'rubydora'
        # Please note: these parameters were used in building the VCR cassettes, so please don't change them.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
      end

      def assign_work_type_from(object)
        object.models.each do |model|
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
        datastream_parser.call(datastream: datastream, entity: entity) do |property|
          entity.properties << property
        end
      end
    end
  end
end
