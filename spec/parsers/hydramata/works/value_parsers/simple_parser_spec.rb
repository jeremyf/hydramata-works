require 'spec_fast_helper'
require 'hydramata/works/value_parsers/simple_parser'
require 'hydramata/works/linters'

module Hydramata
  module Works
    module ValueParsers
      describe SimpleParser do
        it_behaves_like 'a value parser'

        context '.call' do
          let(:object) { double('Object') }
          it 'makes no effort to to convert the object' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: object, raw_object: object)
          end
        end
      end
    end
  end
end
