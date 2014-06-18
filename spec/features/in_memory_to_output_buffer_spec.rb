require 'feature_helper'

module Hydramata
  module Work
    describe 'An entity and presentation structure' do
      context 'renders :show action' do
        let(:presentation_context) { :show }

        it 'as a well-structured HTML document' do
          renderer = EntityRenderer.new(entity: entity_presenter, format: :html)
          rendered_output = renderer.render

          expect(rendered_output).to have_tag('.work') do
            with_tag('.required .title .label', text: 'My Special Title')
            with_tag('.required .title .value', text: 'Hello')
            with_tag('.required .title .value', text: 'World')
            with_tag('.required .title .value', text: 'Bang!')
            with_tag('.optional .abstract .label', text: 'Very Specific Abstract Label')
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

          expect(json['work']['work_type']).to eq(entity_presenter.work_type.to_s)
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

      let(:predicate_title) { Predicates::Storage.new(identity: 'title') }
      let(:predicate_abstract) { Predicates::Storage.new(identity: 'abstract') }
      let(:predicate_keyword) { Predicates::Storage.new(identity: 'keyword') }
      let(:work_type) { WorkTypes::Storage.new(identity: 'Special Work Type') }
      let(:predicate_set_required) { PredicateSets::Storage.new(identity: 'required', work_type: work_type, presentation_sequence: 1) }
      let(:predicate_set_optional) { PredicateSets::Storage.new(identity: 'optional', work_type: work_type, presentation_sequence: 2) }

      around do |example|
        begin
          # @TODO - The structure of the hash is not ideal. The order of keys is
          # somewhat counter-intuitive.
          old_backend = I18n.backend
          I18n.backend = old_backend.clone
          I18n.backend.store_translations(
            :en, { hydramata: { work: {
                                  'title' => { properties: { name: 'My Special Title' } },
                                  'special_work_type/abstract' => { properties: { name: 'Very Specific Abstract Label' } },
                                  'abstract' => { properties: { name: 'Less Specific Abstract Label' } },
            } } }
          )
          example.run
        ensure
          I18n.backend = old_backend
        end
      end

      before do
        predicate_title.save!
        predicate_abstract.save!
        predicate_keyword.save!
        work_type.save!
        predicate_set_optional.save!
        predicate_set_required.save!
        PredicatePresentationSequences::Storage.create!(predicate: predicate_title, predicate_set: predicate_set_required, presentation_sequence: 1)
        PredicatePresentationSequences::Storage.create!(predicate: predicate_abstract, predicate_set: predicate_set_optional, presentation_sequence: 1)
        PredicatePresentationSequences::Storage.create!(predicate: predicate_keyword, predicate_set: predicate_set_optional, presentation_sequence: 2)
      end

      let(:entity) do
        Entity.new do |entity|
          entity.work_type = work_type
          entity.properties << { predicate: predicate_title, value: 'Hello' }
          entity.properties << { predicate: predicate_title, value: 'World' }
          entity.properties << { predicate: predicate_title, value: 'Bang!' }
          entity.properties << { predicate: predicate_abstract, value: 'Long Text' }
          entity.properties << { predicate: predicate_abstract, value: 'Longer Text' }
          entity.properties << { predicate: predicate_keyword, value: 'Programming' }
        end
      end

      let(:presentation_structure) do
        PresentationStructure.new do |structure|
          structure.fieldsets << predicate_set_required
          structure.fieldsets << predicate_set_optional
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

    end
  end
end
