require 'spec_helper'

module Hydramata
  module Work
    describe EntityRenderer do
      let(:context) { :show }
      let(:entity) { double('Entity') }
      let(:presentation_structure) { double('Presentation Structure') }
      let(:template) { double('Template', render: true)}
      subject do
        Hydramata::Work::EntityRenderer.new(
          format: :html,
          template_name_prefix: 'hello/world',
          context: context,
          entity: entity,
          template: template,
          presentation_structure: presentation_structure
        )
      end

      it 'should render the template based on all the inputs' do
        subject.render
        template_name = "hello/world/#{context}"

        expect(template).to have_received(:render).
        with(
          file: template_name,
          locals: { entity: entity, presentation_structure: presentation_structure }
        )
      end
    end
  end
end
