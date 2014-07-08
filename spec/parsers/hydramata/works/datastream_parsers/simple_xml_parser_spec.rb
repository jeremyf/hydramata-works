require 'spec_fast_helper'
require 'hydramata/works/datastream_parsers/simple_xml_parser'
require 'hydramata/works/linters'

module Hydramata
  module Works
    module DatastreamParsers
      describe SimpleXmlParser do
        it_behaves_like 'a datastream parser'

        context '.call' do
          let(:content) { '<fields>\n  <depositor>Username-1</depositor>\n</fields>' }
          it 'should find the appropriate parser based on input options' do
            expect { |b| described_class.call(content, &b) }.to yield_with_args(predicate: 'depositor', value: 'Username-1')
          end
        end

        context '.match?' do
          let(:xml_datastream) { double(content: '<xml>', mimeType: 'application/xml') }
          let(:non_xml_datastream) { double(content: '', mimeType: 'text/plain') }
          it 'should not match when no datastream is provided' do
            expect(described_class.match?).to be_falsey
          end

          it 'should match when an RDF ntriples datastream is provided' do
            expect(described_class.match?(datastream: xml_datastream)).to eq(described_class)
          end

          it 'should not match when the data stream does not appear to be RDF ntriples' do
            expect(described_class.match?(datastream: non_xml_datastream)).to be_falsey
          end
        end

      end
    end
  end
end
