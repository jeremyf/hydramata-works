require 'fast_helper'
require 'hydramata/work/presented_entity'

module Hydramata
  module Work
    describe PresentedEntity do
      it_behaves_like 'a presented entity'

      let(:presentation_structure) { double('PresentationStructure') }
      let(:entity) { double('Entity', entity_type: true) }
      let(:presented_fieldset_builder) { double('Builder', call: true) }
      subject { described_class.new(entity: entity, presentation_structure: presentation_structure, presented_fieldset_builder: presented_fieldset_builder) }

      it 'should have #fieldsets that are extracted from the #entity and #presentation_structure' do
        subject.fieldsets
        expect(presented_fieldset_builder).to have_received(:call).with(entity: entity, presentation_structure: presentation_structure)
      end

      it 'delegates :entity_type to :entity' do
        subject.entity_type
        expect(entity).to have_received(:entity_type)
      end
    end
  end
end
