require 'spec_fast_helper'
require 'hydramata/work/datastream_parser'
require 'hydramata/work/linters'

module Hydramata
  module Work
    describe DatastreamParser do
      context '.parser_for' do
        let(:a_parser) { double('A Parser') }
        let(:parser_finder) { double('Parser Finder', call: a_parser) }
        let(:datastream) { double('Datastream') }
        let(:options) { { parser_finder: parser_finder, datastream: datastream } }
        it 'should find the appropriate parser based on input options' do
          expect(described_class.parser_for(options)).to eq(a_parser)
          expect(parser_finder).to have_received(:call).with(options)
        end
      end

      context '.call' do
        let(:content) { '<fields>\n  <depositor>Username-1</depositor>\n</fields>' }
        let(:datastream) { double('Datastream', content: content, mimeType: 'text/xml') }
        let(:options) { { datastream: datastream } }
        it 'should find the appropriate parser based on input options' do
          expect { |b| described_class.call(options, &b) }.to yield_with_args(predicate: 'depositor', value: 'Username-1')
        end
      end
    end
  end
end
