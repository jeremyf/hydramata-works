require 'spec_fast_helper'
require 'hydramata/works/property_presenter'
require 'hydramata/works/entity'

module Hydramata
  module Works
    describe PropertyPresenter do
      let(:entity) { Entity.new(work_type: 'an entity type') }
      let(:property) { double('Property', predicate: 'my_property') }
      let(:template) { double('Template', render: true) }
      subject do
        described_class.new(
          property: property,
          entity: entity,
          presentation_context: 'show',
          template_missing_exception: [RuntimeError]
        )
      end

      it 'should attempt to render with diminishing specificity' do
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/properties/an_entity_type/my_property/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/properties/my_property/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/properties/show', object: subject).
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
