require 'fast_helper'
require 'hydramata/work/presented_entity'

module Hydramata
  module Work
    describe PresentedEntity do
      let(:presentation_structure) { double('PresentationStructure', fieldsets: [[:required, [:title]], [:optional, [:abstract]]]) }
      let(:entity) { double('Entity', property: true, entity_type: true) }
      let(:properties) { { title: double, abstract: double } }
      subject { described_class.new(entity: entity, presentation_structure: presentation_structure) }

      it 'should yield fieldsets with corresponding properties' do
        entity.should_receive(:property).with(:title).and_return(properties[:title])
        entity.should_receive(:property).with(:abstract).and_return(properties[:abstract])
        expect{|b| subject.each_fieldset_with_properties(&b) }.
        to yield_successive_args(
          [:required, {title: properties[:title]}],
          [:optional, {abstract: properties[:abstract]}]
        )
      end

      it 'delegates :entity_type to :entity' do
        subject.entity_type
        expect(entity).to have_received(:entity_type)
      end
    end
  end
end
