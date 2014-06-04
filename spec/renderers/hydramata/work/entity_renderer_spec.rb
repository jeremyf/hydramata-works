require 'fast_helper'
require 'hydramata/work/entity_renderer'

module Hydramata
  module Work
    describe EntityRenderer do
      let(:context) { :show }
      let(:entity) { double('Entity', render: true) }
      let(:presentation_structure) { double('Presentation Structure') }
      let(:template) { double('Template')}
      subject do
        Hydramata::Work::EntityRenderer.new(entity: entity, format: :html, context: context, template: template)
      end

      it 'should render the template based on all the inputs' do
        subject.render
        expect(entity).to have_received(:render).with(template: template)
      end
    end
  end
end
