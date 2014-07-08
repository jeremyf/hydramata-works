require 'spec_fast_helper'
require 'hydramata/works/value_parsers'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    module ValueParsers
      class MockParser
      end
    end
    describe ValueParsers do
      let(:predicate) { Predicate.new(value_parser_name: parser_class_name) }

      context 'existing parser in ValueParsers namespace' do
        let(:parser_class_name) { 'MockParser' }
        it 'should use that' do
          expect(described_class.find(predicate: predicate)).to eq ValueParsers::MockParser
        end
      end

      context 'an escaped namespace class' do
        let(:parser_class_name) { '::Object' }
        it 'will fallback to the simple parser' do
          expect(described_class.find(predicate: predicate)).to eq ValueParsers::SimpleParser
        end
      end

      context 'a constant not in the namespace' do
        let(:parser_class_name) { 'MissingParser' }
        it 'will fallback to the simple parser' do
          expect(described_class.find(predicate: predicate)).to eq ValueParsers::SimpleParser
        end
      end
    end
  end
end
