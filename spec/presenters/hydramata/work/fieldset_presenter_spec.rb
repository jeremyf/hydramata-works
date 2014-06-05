require 'fast_helper'
require 'hydramata/work/fieldset_presenter'

module Hydramata
  module Work
    describe FieldsetPresenter do
      let(:fieldset_class) { Struct.new(:name) }
      let(:fieldset) { fieldset_class.new('my_fieldset') }
      let(:entity) { double('Entity', work_type: 'an entity type') }
      let(:template) { double('Template', render: true) }
      subject { described_class.new(entity: entity, fieldset: fieldset, presentation_context: 'show') }

      it 'should render as per the template' do
        subject.render(template: template)
        expect(template).
          to have_received(:render).
          with(partial: 'hydramata/work/fieldsets/show', object: subject)
      end

      it 'should have an #work_type' do
        expect(subject.work_type).to eq(entity.work_type)
      end

      it 'should be an instance of the presented object\'s class' do
        expect(subject.instance_of?(fieldset.class)).to be_truthy
      end

      it 'should also be an instance of the presenter class' do
        expect(subject.instance_of?(described_class)).to be_truthy
      end

      it 'should have a #dom_class' do
        expect(subject.dom_class).to eq('my-fieldset')
      end

    end
  end
end
