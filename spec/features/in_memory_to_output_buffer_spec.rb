require 'feature_helper'

module Hydramata
  module Work
    describe 'An entity and presentation structure' do
      let(:entity) do
        Entity.new.tap do |entity|
          entity.work_type = 'Special Work Type'
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

      context 'renders :show action' do
        let(:presentation_context) { :show }

        it 'as a well-structured HTML document' do
          renderer = EntityRenderer.new(entity: entity_presenter, format: :html)
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

        it 'as a JSON document' do
          renderer = EntityRenderer.new(entity: entity_presenter, format: :json)
          output = renderer.render
          json = JSON.parse(output)
          expect(json['work']['fieldsets']['required']['properties']['title']['values']).to eq(['Hello', 'World', 'Bang!'])
        end
      end
    end
  end
end
