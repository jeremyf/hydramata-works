require 'fast_helper'
require 'hydramata/work/value_parser'

module Hydramata
  module Work
    describe ValueParser do
      let(:predicate) { double('Predicate') }
      let(:value) { double('Value') }
      let(:a_parser) { double('A Parser', call: true) }
      let(:parser_finder) { double('Parser Finder', call: a_parser) }

      context '.call' do
        let(:options) { { predicate: predicate, work_type: 'article', parser_finder: parser_finder, value: value } }
        it 'coordinate with the parser_finder and calls the found parser' do
          parsed_value = '1234'
          expect(a_parser).to receive(:call).with(value).and_yield(value: parsed_value)
          expect { |b| described_class.call(options, &b) }.to yield_with_args(value: parsed_value)
        end
      end
    end
  end
end
