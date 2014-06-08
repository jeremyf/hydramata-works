require 'fast_helper'
require 'hydramata/work/predicate_parser'

module Hydramata
  module Work
    describe PredicateParser do

      let(:predicate) { double('Predicate') }
      let(:value) { double('Value') }

      context '.parser_for' do
        let(:a_parser) { double('A Parser', call: true) }
        let(:parser_finder) { double('Parser Finder', call: a_parser) }
        let(:options) { { predicate: predicate, work_type: 'article', parser_finder: parser_finder, value: value } }
        it 'should find the appropriate parser based on the predicate and work_type' do
          expect(described_class.parser_for(options)).to eq(a_parser)
          expect(parser_finder).to have_received(:call).with(options)
        end
      end

      context '.call' do
        let(:options) { { predicate: predicate, work_type: 'article', value: value } }
        it 'coordinates with the parser_finder and calls the found parser' do
          expect { |b| described_class.call(options, &b) }.to yield_with_args(value: value)
        end
      end

    end
  end
end
