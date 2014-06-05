module Hydramata
  module Work
    # Responsible for finding the appropriate datastream parser based on the
    # input context, then calling the found parser.
    #
    # See lib/hydramata/work/linters.rb for the interface definition of a
    # datastream parser.
    module DatastreamParser
      module_function

      def call(options = {}, &block)
        datastream = options.fetch(:datastream)
        parser = parser_for(options)
        parser.call(datastream.content, &block)
      end

      def parser_for(options = {})
        parser_finder = options.fetch(:parser_finder) { default_parser_finder }
        parser_finder.call(options)
      end

      def default_parser_finder
        # @TODO - This logic is rather gnarly and also dense. Consider a parser
        # registery. The first parser that says it matches, does the work.
        lambda do |options|
          datastream = options.fetch(:datastream)
          null_parser = proc { }
          case datastream.mimeType
          when 'text/xml'
            require 'hydramata/work/datastream_parsers/simple_xml_parser'
            DatastreamParsers::SimpleXmlParser
          when 'application/rdf+xml' then null_parser
          when 'text/plain'
            content = datastream.content
            if content =~ /\A\<info:fedora/
              require 'hydramata/work/datastream_parsers/rdf_ntriples_parser'
              DatastreamParsers::RdfNtriplesParser
            else
              null_parser
            end
          else
            null_parser
          end
        end
      end
      private_class_method :default_parser_finder
    end
  end
end
