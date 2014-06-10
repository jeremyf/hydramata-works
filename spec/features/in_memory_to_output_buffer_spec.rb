require 'feature_helper'

module Hydramata
  module Work
    describe 'An entity and presentation structure' do
      let(:entity) do
        Entity.new do |entity|
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
        PresentationStructure.new do |structure|
          structure.fieldsets << [:required, [:title]]
          structure.fieldsets << [:optional, [:abstract, :keyword]]
        end
      end

      let(:presentation_context) { :show }

      let(:entity_presenter) do
        EntityPresenter.new(
          entity: entity,
          presentation_structure: presentation_structure,
          presentation_context: presentation_context
        )
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
          expect(json['work'].keys.sort).to eq(['properties', 'work_type'])

          expect(json['work']['properties'].keys).to eq(['title', 'abstract', 'keyword'])
          expect(json['work']['properties']['title']).to eq(['Hello', 'World', 'Bang!'])
          expect(json['work']['properties']['abstract']).to eq(['Long Text', 'Longer Text'])
          expect(json['work']['properties']['keyword']).to eq(['Programming'])
        end
      end

      context 'renders :edit action' do
        let(:presentation_context) { :edit }

        it 'as a well-structured HTML document' do
          renderer = EntityRenderer.new(entity: entity_presenter, format: :html)
          rendered_output = renderer.render

          expect(rendered_output).to have_tag('form.edit-special-work-type', with: { method: 'post', action: '/' }) do
            with_tag('input', with: { name: '_method', value: 'patch' } )
            with_tag('fieldset.required caption', text: 'required')
            with_tag('fieldset.required .title label', text: 'title')
            with_tag('fieldset.required .title .values input', value: 'Hello', with: { name: 'work[title][]' })
            with_tag('fieldset.required .title .values input', value: 'World', with: { name: 'work[title][]' })
            with_tag('fieldset.required .title .values input', value: 'Bang!', with: { name: 'work[title][]' })
            with_tag('fieldset.required .title .values input', value: '', with: { name: 'work[title][]' })
            with_tag('fieldset.optional caption', text: 'optional')
            with_tag('fieldset.optional .abstract label', text: 'abstract')
            with_tag('fieldset.optional .abstract .values input', value: 'Long Text', with: { name: 'work[abstract][]' })
            with_tag('fieldset.optional .abstract .values input', value: 'Longer Text', with: { name: 'work[abstract][]' })
            with_tag('fieldset.optional .abstract .values input', value: '', with: { name: 'work[abstract][]' })
            with_tag('fieldset.optional .keyword label', text: 'keyword')
            with_tag('fieldset.optional .keyword .values input', value: 'Programming', with: { name: 'work[keyword][]' })
            with_tag('fieldset.optional .keyword .values input', value: '', with: { name: 'work[keyword][]' })
          end
        end

      end
    end
  end
end
