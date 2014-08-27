require 'spec_fast_helper'
require 'hydramata/works/value_parsers/interrogation_parser'

module Hydramata
  module Works
    module ValueParsers
      describe InterrogationParser do
        context 'basic object' do
          let(:object) { 'string' }
          it 'sends the object through a switch case' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: object, raw_object: object)
          end
        end

        context 'basic object' do
          let(:object) { RDF::Literal.new("Hello!", :language => :en) }
          it 'sends the object through a switch case' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: 'Hello!', raw_object: object)
          end
        end
      end
    end
  end
end
