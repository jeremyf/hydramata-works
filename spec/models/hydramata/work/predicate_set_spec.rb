require 'fast_helper'
require 'hydramata/work/predicate_set'
require 'hydramata/work/linters/implement_predicate_set_interface_matcher'

module Hydramata
  module Work
    describe PredicateSet do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_predicate_set_interface }

      it 'should initialize via attributes' do
        expect(subject.identity).to eq('My Identity')
      end

      it 'should initialize via attributes' do
        expect(subject.identity).to eq('My Identity')
      end

      context 'comparability' do
        let(:work_type) { 'Work Type' }
        let(:identity) { 'Identity' }
        subject { described_class.new(identity: 'Identity', work_type: work_type) }

        it 'is != if they are different base classes' do
          other = double(work_type: work_type, identity: identity)
          expect(subject == other).to be_falsey
        end

        it 'is == if they are the same object' do
          expect(subject == subject).to be_truthy
        end

        it 'is == if work type and identity are the same' do
          other = described_class.new(identity: identity, work_type: work_type)
          expect(subject == other).to be_truthy
        end

        it 'is != if work type is the same but not identity' do
          other = described_class.new(identity: identity + 'not', work_type: work_type)
          expect(subject == other).to be_falsey
        end

        it 'is != if identity is the same but not work type' do
          other = described_class.new(identity: identity, work_type: work_type + 'not')
          expect(subject == other).to be_falsey
        end

        it 'is "nil" when we are comparing against other objects' do
          other = double("Other")
          expect(subject <=> other).to be_nil
        end

        it 'is based on the array underlying array' do
          other = described_class.new(identity: 'Z' + identity, work_type: 'A' + work_type)
          # The other one is greater than this one
          expect(subject <=> other).to eq(1)
        end

      end

    end
  end
end
