require 'spec_fast_helper'
require 'hydramata/works/work_presenter'
require 'hydramata/works/work'
require 'hydramata/works/linters/implement_work_presenter_interface_matcher'
require 'hydramata/works/linters/implement_work_type_presenter_interface_matcher'

module Hydramata
  module Works
    describe WorkPresenter do

      let(:presentation_structure) { double('PresentationStructure') }
      let(:work) { Work.new(work_type: 'My Work Type') }
      let(:presented_fieldset_builder) { double('Builder', call: true) }
      let(:template) { double('Template', render: true) }
      let(:renderer) { double('Renderer', call: true) }
      let(:collaborators) do
        {
          work: work,
          presentation_structure: presentation_structure,
          presented_fieldset_builder: presented_fieldset_builder,
          renderer: renderer
        }
      end
      subject { described_class.new(collaborators) }

      it 'yields the presenter if a block is given' do
        expect{|b| described_class.new(collaborators, &b) }.to yield_with_args(described_class)
      end

      it { should implement_work_presenter_interface }

      it 'has a presented work type' do
        expect(subject.work_type).to implement_work_type_presenter_interface
      end

      it 'has #container_content_tag_attributes' do
        expect(subject.container_content_tag_attributes.keys).to eq([:class, :itemscope, :itemtype])
      end

      it 'has #fieldsets that are extracted from the #work and #presentation_structure' do
        subject.fieldsets
        expect(presented_fieldset_builder).to have_received(:call).with(work: subject, presentation_structure: presentation_structure)
      end

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['my_work_type']])
      end

      it 'renders as per the template' do
        expect(renderer).to receive(:call).with(template, kind_of(Hash)).and_return('YES')
        expect(subject.render(template)).to eq('YES')
      end

    end
  end
end
