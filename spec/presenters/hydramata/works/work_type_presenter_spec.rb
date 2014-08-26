require 'spec_fast_helper'
require 'hydramata/works/work_type'
require 'hydramata/works/work_type_presenter'
require 'hydramata/works/linters/implement_work_type_presenter_interface_matcher'

module Hydramata
  module Works
    describe WorkTypePresenter do
      let(:work_type) { WorkType.new(identity: 'article') }
      let(:translator) { double('Translator') }
      subject { described_class.new(work_type, translator: translator) }
      it { should implement_work_type_presenter_interface }

      context '#description' do
        it 'uses translation services' do
          expect(translator).
            to receive(:translate).
            with('description', scopes: [['work_types', work_type.to_translation_key_fragment]]).
            and_return('An Article Description')
          expect(subject.description).to eq('An Article Description')
        end
      end

      context '#name' do
        it 'uses translation services' do
          expect(translator).
            to receive(:translate).
            with('name', scopes: [['work_types', work_type.to_translation_key_fragment]], default: work_type.name).
            and_return('An Article')
          expect(subject.name).to eq('An Article')
        end
      end

      it 'has a friendly inspect message, because tracking it down could be a pain' do
        expect(subject.inspect).to include("#{described_class}")
        expect(subject.inspect).to include(work_type.inspect)
      end

      it 'is an instance of the presented object\'s class' do
        expect(subject.instance_of?(work_type.class)).to be_truthy
        expect(subject.instance_of?(described_class)).to be_truthy
      end

    end
  end
end
