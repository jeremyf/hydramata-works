require 'fast_helper'
require 'hydramata/work/presented_fieldset'

module Hydramata
  module Work
    describe PresentedFieldset do
      let(:fieldset) { double('Fieldset', name: 'my fieldset') }
      let(:entity) { double('Entity', entity_type: 'an entity type') }
      let(:template) { double('Template', render: true) }
      subject { described_class.new(entity: entity, fieldset: fieldset) }

      it 'should render as per the template' do
        subject.render(template)
        expect(template).to have_received(:render)
      end

      it 'should have a #name' do
        expect(subject.name).to eq(fieldset.name)
      end

      it 'should have an #entity_type' do
        expect(subject.entity_type).to eq(entity.entity_type)
      end
    end
  end
end