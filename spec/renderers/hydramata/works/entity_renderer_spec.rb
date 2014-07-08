require 'spec_fast_helper'
require 'hydramata/works/entity_renderer'

module Hydramata
  module Works
    describe EntityRenderer do
      let(:entity) { double('Entity', render: true) }
      let(:presentation_structure) { double('Presentation Structure') }
      let(:template) { double('Template') }
      subject do
        Hydramata::Works::EntityRenderer.new(entity: entity, format: :html, template: template)
      end

      it 'should render the template based on all the inputs' do
        subject.render
        expect(entity).to have_received(:render).with(template: template)
      end

      it 'should default to :html format' do
        renderer = Hydramata::Works::EntityRenderer.new(entity: entity, template: template)
        expect(renderer.format).to eq(:html)
      end
    end
  end
end
