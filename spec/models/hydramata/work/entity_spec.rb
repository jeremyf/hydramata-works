require 'fast_helper'
require 'hydramata/work/entity'

module Hydramata
  module Work
    describe Entity do
      subject { described_class.new }
      let(:predicate) { :title }
      let(:value) { 'Hello' }
      let(:property) { { predicate: predicate, value: value } }
      context '#properties' do
        it 'can be appended' do
          expect {
            subject.properties << property
          }.to change { subject.properties.count }.by(1)
        end
      end

      context '#property' do
        it 'returns matching predicates' do
          subject.properties << property
          expect(subject.property(predicate)).to eq([value])
        end
      end
    end
  end
end
