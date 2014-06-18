require 'fast_helper'
require 'hydramata/work/property_presenter'

module Hydramata
  module Work
    describe PropertyPresenter do
      let(:fieldset) { double('Fieldset') }
      let(:entity) { double('Entity', work_type: 'an entity type') }
      let(:property) { double('Property', predicate: 'my_property') }
      let(:template) { double('Template', render: true) }
      subject do
        described_class.new(
          property: property,
          entity: entity,
          fieldset: fieldset,
          presentation_context: 'show',
          template_missing_exception: [RuntimeError]
        )
      end

      it 'should attempt to render with diminishing specificity' do
        expect(template).to receive(:render).
          with(partial: 'hydramata/work/properties/an_entity_type/my_property/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/work/properties/my_property/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/work/properties/show', object: subject).
          ordered.
          and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

      it 'should have a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['an_entity_type','my_property'], ['my_property']])
      end

    end
  end
end
