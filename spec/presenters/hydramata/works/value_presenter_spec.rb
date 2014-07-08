require 'spec_fast_helper'
require 'hydramata/works/value_presenter'
require 'hydramata/works/entity'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe ValuePresenter do
      let(:entity) { Entity.new(work_type: 'an entity type') }
      let(:predicate) { Predicate.new(identity: 'a predicate') }
      let(:value) { double('Value') }
      let(:template) { double('Template', render: true) }
      subject do
        described_class.new(
          value: value,
          entity: entity,
          predicate: predicate,
          presentation_context: 'show',
          template_missing_exception: [RuntimeError]
        )
      end

      it 'should attempt to render with diminishing specificity' do
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/values/an_entity_type/a_predicate/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/values/a_predicate/show', object: subject).
          ordered.
          and_raise(RuntimeError)
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/values/show', object: subject).
          ordered.
          and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

      it 'should render the value as a string' do
        allow(template).to receive(:render).and_raise(RuntimeError)
        expect(subject.render(template: template)).to eq(value.to_s)
      end

      it 'should have a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['an_entity_type','a_predicate'], ['a_predicate']])
      end
    end
  end
end
