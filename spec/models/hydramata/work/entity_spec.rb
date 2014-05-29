require 'fast_helper'

module Hydramata
  module Work
    describe Entity do
      subject { described_class.new }
      it 'has an #entity_type' do
        expect(subject).to respond_to(:entity_type)
      end
    end
  end
end
