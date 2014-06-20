require 'spec_fast_helper'
require 'hydramata/work/entity'
require 'hydramata/work/linters'

module Hydramata
  module Work
    describe Entity do
      subject { described_class.new }
      it_behaves_like 'a work entity'

      let(:predicate) { :title }
      let(:value) { 'Hello' }
      let(:property) { Property.new(predicate: predicate, value: value) }

      it { should respond_to :work_type }
      it { should respond_to :work_type= }

      context '#properties' do
        it 'can be appended' do
          expect { subject.properties << property }.
            to change { subject.properties.count }.
            by(1)
        end
      end

      context '#property' do
        it 'returns matching predicates' do
          subject.properties << property
          expect(subject.properties[predicate]).to eq(property)
        end
      end
    end
  end
end
