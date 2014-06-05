require 'fast_helper'
require 'hydramata/work/datastream_parsers/simple_xml_parser'
require 'hydramata/work/linters'

module Hydramata
  module Work
    module DatastreamParsers
      describe SimpleXmlParser do
        it_behaves_like 'a datastream parser'

        context '.call' do
          let(:content) { '<fields>\n  <depositor>Username-1</depositor>\n</fields>' }
          it 'should find the appropriate parser based on input options' do
            expect { |b| described_class.call(content, &b) }.to yield_with_args(predicate: 'depositor', value: 'Username-1')
          end
        end
      end
    end
  end
end
