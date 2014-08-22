require 'spec_fast_helper'
require 'hydramata/works/work_form'
require 'hydramata/works/linters'
require 'hydramata/works/work'
require 'hydramata/works/linters/implement_work_form_interface_matcher'

module Hydramata
  module Works
    describe WorkForm do
      let(:identity) { nil }
      let(:validation_service) { double(call: true) }
      let(:work) do
        Work.new(identity: identity) do |work|
          work.properties << { predicate: :first_name, value: 'Jeremy' }
        end
      end
      subject { described_class.new(work, validation_service: validation_service) }

      it_behaves_like 'ActiveModel'

      it { should be_an_instance_of WorkForm }
      it { should be_an_instance_of Work }
      it { should implement_work_form_interface }

      context 'when errors are not set' do
        let(:validation_service) { double(call: true) }
        it 'is not valid' do
          expect(subject.valid?).to be_truthy
          expect(validation_service).to have_received(:call)
        end
      end
      context 'when errors are encountered' do
        let(:validation_service) { ->(work) { work.errors.add(:base, 'Found some errors!') } }
        it 'is valid' do
          expect(subject.valid?).to be_falsey
        end
      end

      it 'has a meaningful inspect' do
        expect(subject.inspect).to include("WorkForm")
        expect(subject.inspect).to include(work.inspect)
      end

      context 'work\'s properties' do
        it 'responds to a given predicate' do
          expect(subject).to respond_to(:first_name)
        end

        it 'exposes the predicate name as a method' do
          expect(subject.first_name).to eq(['Jeremy'])
        end
      end

      context 'with collaborating work without an identity' do
        let(:identity) { '' }
        it 'is not #persisted?' do
          expect(subject.persisted?).to be_falsey
        end

        it 'has a nil #to_param' do
          expect(subject.to_param).to be_nil
        end

        it 'has a nil #to_key' do
          expect(subject.to_key).to be_nil
        end
      end

      context 'with collaborating work with an identity' do
        let(:identity) { '1234' }
        it 'is #persisted?' do
          expect(subject.persisted?).to be_truthy
        end

        it 'uses the work#identity to derive #to_param' do
          expect(subject.to_param).to eq(identity)
        end

        it 'uses the work#identity to derive #to_key' do
          expect(subject.to_key).to eq([identity])
        end

      end
    end
  end
end
