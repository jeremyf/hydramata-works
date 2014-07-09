require 'spec_slow_helper'

module Hydramata
  module Works
    describe 'A work and presentation structure' do

      let(:work) do
        Work.new do |work|
          work.work_type = work_type
          work.properties << { predicate: predicate_title, value: 'Hello' }
          work.properties << { predicate: predicate_title, value: 'World' }
          work.properties << { predicate: predicate_title, value: 'Bang!' }
          work.properties << { predicate: predicate_abstract, value: 'Long Text' }
          work.properties << { predicate: predicate_abstract, value: 'Longer Text' }
          work.properties << { predicate: predicate_keyword, value: 'Programming' }
        end
      end

      context 'rendering a :show action' do
        let(:presentation_context) { :show }

        it 'writes a well-structured HTML document' do
          renderer = WorkRenderer.new(work: work_presenter, format: :html)
          rendered_output = renderer.render

          expect(rendered_output).to have_tag('.work') do
            with_tag('.required .title.label', text: 'title')
            with_tag('.required .title.value', text: 'Hello')
            with_tag('.required .title.value', text: 'World')
            with_tag('.required .title.value', text: 'Bang!')
            with_tag('.optional .abstract.label', text: 'abstract')
            with_tag('.optional .abstract.value', text: 'Long Text')
            with_tag('.optional .abstract.value', text: 'Longer Text')
            with_tag('.optional .keyword.label', text: 'keyword')
            with_tag('.optional .keyword.value', text: 'Programming')
          end
        end

        it 'writes a well-structure JSON document' do
          renderer = WorkRenderer.new(work: work_presenter, format: :json)
          output = renderer.render
          json = JSON.parse(output)
          expect(json['work'].keys.sort).to eq(['properties', 'work_type'])

          expect(json['work']['work_type']).to eq(work_presenter.work_type.to_s)
          expect(json['work']['properties'].keys).to eq(['title', 'abstract', 'keyword'])
          expect(json['work']['properties']['title']).to eq(['Hello', 'World', 'Bang!'])
          expect(json['work']['properties']['abstract']).to eq(['Long Text', 'Longer Text'])
          expect(json['work']['properties']['keyword']).to eq(['Programming'])
        end
      end

      context 'rendering an :edit action' do
        let(:presentation_context) { :edit }

        it 'writes a well-structured HTML document' do
          renderer = WorkRenderer.new(work: work_presenter, format: :html)
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

      let(:presentation_context) { :show }

      let(:work_presenter) do
        WorkPresenter.new(
          work: work,
          presentation_context: presentation_context
        )
      end

    end
  end
end
