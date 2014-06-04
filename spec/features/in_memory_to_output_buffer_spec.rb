require 'feature_helper'

module Hydramata
  module Work
    describe 'An entity and presentation structure' do
      let(:entity) do
        Entity.new.tap do |entity|
          entity.properties << { predicate: :title, value: 'Hello' }
          entity.properties << { predicate: :title, value: 'World' }
          entity.properties << { predicate: :title, value: 'Bang!' }
          entity.properties << { predicate: :abstract, value: 'Long Text' }
          entity.properties << { predicate: :abstract, value: 'Longer Text' }
          entity.properties << { predicate: :keyword, value: 'Programming' }
        end
      end

      let(:presentation_structure) do
        PresentationStructure.new.tap do |struct|
          struct.fieldsets << [:required, [:title]]
          struct.fieldsets << [:optional, [:abstract, :keyword]]
        end
      end

      let(:presentation_context) { :show }

      let(:entity_presenter) do
        EntityPresenter.new(entity: entity, presentation_structure: presentation_structure, presentation_context: presentation_context)
      end

      let(:renderer) do
        EntityRenderer.new(entity: entity_presenter, content_type: :html)
      end

      context 'renders :show action' do
        let(:presentation_context) { :show }

        it 'as a well-structured HTML document' do
          rendered_output = renderer.render

          expect(rendered_output).to have_tag('.work') do
            with_tag('.required .title .label', text: 'title')
            with_tag('.required .title .value', text: 'Hello')
            with_tag('.required .title .value', text: 'World')
            with_tag('.required .title .value', text: 'Bang!')
            with_tag('.optional .abstract .label', text: 'abstract')
            with_tag('.optional .abstract .value', text: 'Long Text')
            with_tag('.optional .abstract .value', text: 'Longer Text')
            with_tag('.optional .keyword .label', text: 'keyword')
            with_tag('.optional .keyword .value', text: 'Programming')
          end
        end
      end
    end
  end
end
