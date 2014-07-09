require 'spec_fast_helper'
require 'hydramata/works/datastream_parsers/simple_xml_parser'
require 'hydramata/works/linters/implement_datastream_parser_interface_matcher'

module Hydramata
  module Works
    module DatastreamParsers
      describe SimpleXmlParser do
        subject { described_class }

        it { should implement_datastream_parser_interface }

        context '.call' do
          let(:content) { '<fields>\n  <depositor>Username-1</depositor>\n</fields>' }
          it 'finds the appropriate parser based on input options' do
            expect { |b| subject.call(content, &b) }.to yield_with_args(predicate: 'depositor', value: 'Username-1')
          end
        end

        context '.match?' do
          let(:xml_datastream) { double(content: '<xml>', mimeType: 'application/xml') }
          let(:non_xml_datastream) { double(content: '', mimeType: 'text/plain') }
          it 'does not match when no datastream is provided' do
            expect(subject.match?).to be_falsey
          end

          it 'matches when an RDF ntriples datastream is provided' do
            expect(subject.match?(datastream: xml_datastream)).to eq(subject)
          end

          it 'does not match when the data stream does not appear to be RDF ntriples' do
            expect(subject.match?(datastream: non_xml_datastream)).to be_falsey
          end
        end

      end
    end
  end
end
