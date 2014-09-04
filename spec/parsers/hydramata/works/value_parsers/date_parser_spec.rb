require 'spec_fast_helper'
require 'hydramata/works/value_parsers/date_parser'

module Hydramata
  module Works
    module ValueParsers
      describe DateParser do
        let(:object) { '2014-04-02' }
        it 'sends parses the date' do
          expect { |b| described_class.call(object, &b) }.to yield_with_args(value: Date.new(2014,4,2), raw_object: object)
        end
      end
    end
  end
end
