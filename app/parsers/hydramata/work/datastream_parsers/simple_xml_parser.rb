module Hydramata
  module Work
    module DatastreamParsers
      module SimpleXmlParser
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
