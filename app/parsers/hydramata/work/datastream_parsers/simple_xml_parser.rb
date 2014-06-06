module Hydramata
  module Work
    module DatastreamParsers
      # Responsible for parsing a very simplistic XML document.
      module SimpleXmlParser
        module_function
        def match?(options = {})
          datastream = options[:datastream]
          return false unless datastream
          if datastream.mimeType =~ /\A(application|text)\/xml/
            self
          else
            false
          end
        end

        def call(content, &block)
          require 'nokogiri'
          doc = Nokogiri::XML.parse(content)
          doc.xpath('/fields/*').each do |node|
            block.call(predicate: node.name, value: node.text)
          end
        end
      end
    end
  end
end
