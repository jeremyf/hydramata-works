require 'fast_helper'
require 'hydramata/work/entity'

module Hydramata
  module Work
    describe Entity do
      subject { described_class.new }
      it { expect(subject).to respond_to(:entity_type) }

      context '#properties' do
        let(:property) { { predicate: :title, value: 'Hello' } }
        it 'can be appended' do
          expect {
            subject.properties << property
          }.to change { subject.properties.count }.by(1)
        end
      end
    end
  end
end
