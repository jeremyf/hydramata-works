require 'spec_fast_helper'
require 'hydramata/work/entity_presenter'
require 'hydramata/work/linters'

module Hydramata
  module Work
    describe EntityPresenter do
      it_behaves_like 'a presented entity'

      let(:presentation_structure) { double('PresentationStructure') }
      let(:entity) { Entity.new(work_type: 'My Work Type') }
      let(:presented_fieldset_builder) { double('Builder', call: true) }
      let(:template) { double('Template', render: true) }
      subject do
        described_class.new(
          entity: entity,
          presentation_structure: presentation_structure,
          presented_fieldset_builder: presented_fieldset_builder,
          template_missing_exception: [RuntimeError]
        )
      end

      it 'should have #fieldsets that are extracted from the #entity and #presentation_structure' do
        subject.fieldsets
        expect(presented_fieldset_builder).to have_received(:call).with(entity: subject, presentation_structure: presentation_structure)
      end

      it 'should have a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['my_work_type']])
      end

      it 'should render as per the template' do
        expect(template).to receive(:render).
          with(partial: 'hydramata/work/works/my_work_type/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/work/works/show', object: subject).
          ordered.
          and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

    end
  end
end
