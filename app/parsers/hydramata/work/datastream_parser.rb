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
        content = options.fetch(:content)
        parser = parser_for(options)
        parser.call(content, &block)
      end

      def parser_for(options = {})
        parser_finder = options.fetch(:parser_finder) { default_parser_finder }
        parser_finder.call(options)
      end

      def default_parser_finder
        # @TODO - This logic is rather gnarly and also dense. Consider a parser
        # registery. The first parser that says it matches, does the work.
        lambda { |options|
          content_type = options.fetch(:content_type)
          null_parser = lambda { |*args| }
          case content_type
          when 'text/xml' then RudimentaryXmlParser
          when 'application/rdf+xml' then null_parser
          when 'text/plain'
            content = options.fetch(:content)
            if content =~ /\A\<info:fedora/
              require 'hydramata/work/datastream_parsers/rdf_ntriples_parser'
              DatastreamParsers::RdfNtriplesParser
            else
              null_parser
            end
          else
            null_parser
          end
        }
      end
      private_class_method :default_parser_finder

      module RudimentaryXmlParser
        module_function
        def call(content, &block)
          require 'nokogiri'
          doc = Nokogiri::XML.parse(content)
          doc.xpath('/fields/*').each do |node|
            yield(predicate: node.name, value: node.text)
          end
        end
      end

    end
  end
end
