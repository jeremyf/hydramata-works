module Hydramata
  module Works
    # Responsible for wrangling up data from Fedora and passing that data to
    # visiting :work.
    class FedoraWrangler

      attr_reader :repository_connection, :work, :datastream_parser
      def initialize(collaborators = {})
        @repository_connection = collaborators.fetch(:repository_connection) { default_repository_connection }
        @datastream_parser = collaborators.fetch(:datastream_parser) { default_datastream_parser }
        @work = collaborators.fetch(:work)
      end

      private

      def default_datastream_parser
        require 'hydramata/works/datastream_parser'
        DatastreamParser
      end

      def default_repository_connection
        require 'rubydora'
        # Please note: these parameters were used in building the VCR cassettes, so change at your own risk.
        # TODO: This should be a configuration option analogous to ActiveFedora.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
      end

      public

      def call(pid, options = {})
        with_datastreams = options.fetch(:with_datastreams) { default_with_datastreams }
        object = repository_connection.find(pid)
        assign_work_type_from(object)
        parse_datastreams(object) if with_datastreams
      end

      private

      def default_with_datastreams
        false
      end

      def assign_work_type_from(object)
        object.models.reverse.each do |model|
          if model =~ /\Ainfo:fedora\/afmodel\:(.*)\Z/
            # @TODO - Should we make sure this exists in the data storage?
            #         Is it a matter of finding either the most specific or
            #         the one that exists? What is the retrieval scheme?
            work.work_type = Regexp.last_match[1]
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
        datastream_parser.call(datastream: datastream, work: work) do |property|
          work.properties << property
        end
      end

    end
  end
end
