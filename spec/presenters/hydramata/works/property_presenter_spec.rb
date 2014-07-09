require 'spec_fast_helper'
require 'hydramata/works/property_presenter'
require 'hydramata/works/work'

module Hydramata
  module Works
    describe PropertyPresenter do
      let(:work) { Work.new(work_type: 'a work type') }
      let(:property) { double('Property', predicate: 'my_property') }
      let(:template) { double('Template', render: true) }
      subject do
        described_class.new(
          property: property,
          work: work,
          presentation_context: 'show',
          template_missing_exception: [RuntimeError]
        )
      end

      it 'attempts to render with diminishing specificity' do
        expect(template).to receive(:render).
          with(partial: 'hydramata/works/properties/an_work_type/my_property/show', object: subject).
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

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['an_work_type','my_property'], ['my_property']])
      end

    end
  end
end
