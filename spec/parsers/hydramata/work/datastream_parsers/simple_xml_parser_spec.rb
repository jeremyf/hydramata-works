require 'fast_helper'
require 'hydramata/work/datastream_parsers/simple_xml_parser'
require 'hydramata/work/linters'

module Hydramata
  module Work
    module DatastreamParsers
      describe SimpleXmlParser do
        it_behaves_like 'a datastream parser'
      end
    end
  end
end
