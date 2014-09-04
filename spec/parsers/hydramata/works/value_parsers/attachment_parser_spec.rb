require 'spec_fast_helper'
require 'hydramata/works/value_parsers/attachment_parser'

module Hydramata
  module Works
    module ValueParsers
      describe AttachmentParser do
        let(:object) { double(original_filename: 'README.txt') }
        it 'sends parses the object for an original_filename' do
          expect { |b| described_class.call(object, &b) }.to yield_with_args(value: 'README.txt', raw_object: object)
        end
      end
    end
  end
end
