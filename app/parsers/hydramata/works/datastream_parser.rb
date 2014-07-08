require 'hydramata/works/datastream_parsers/simple_xml_parser'
require 'hydramata/works/datastream_parsers/rdf_ntriples_parser'

module Hydramata
  module Works
    # Responsible for finding the appropriate datastream parser based on the
    # input context, then calling the found parser.
    #
    # See lib/hydramata/works/linters.rb for the interface definition of a
    # datastream parser.
    module DatastreamParser
      module_function

      def call(options = {}, &block)
        parser = parser_for(options)
        datastream = options.fetch(:datastream)
        parser.call(datastream.content, &block)
      end

      def parser_for(options = {})
        parser_finder = options.fetch(:parser_finder) { default_parser_finder }
        parser_finder.call(options)
      end

      def default_parser_finder
        lambda do |options|
          null_parser = proc {}
          DatastreamParsers::RdfNtriplesParser.match?(options) ||
            DatastreamParsers::SimpleXmlParser.match?(options) ||
            null_parser
        end
      end
      private_class_method :default_parser_finder
    end
  end
end
