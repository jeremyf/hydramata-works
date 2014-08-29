require 'spec_slow_helper'
require 'hydramata/works/conversions/property_set'
require 'hydramata/works/conversions/property'

module Hydramata
  module Works
    describe 'Translation services' do
      include Conversions
      let(:work) { Work.new(work_type: work_type, identity: '123') }

      context 'for entities' do
        let(:presenter) { WorkPresenter.new(work: work, presentation_structure: nil) }
        context 'with existing work type translations' do
          let(:work_type) { 'Work Type Translated' }
          it 'translates its :name from the lookup table' do
            expect(presenter.t(:name)).to eq('I Am a Translated Work Type!')
          end
        end
        context 'with :name_for_application_usage set' do
          let(:work_type) { WorkType.new(identity: 'Work Type Translated', name_for_application_usage: 'Work Type with Translated Name') }
          it 'translates its :name from the lookup table' do
            expect(presenter.t(:name)).to eq('I Am Translating the Name for Application Usage!')
          end
        end
        context 'without existing work type translations' do
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name by using the work type directly' do
            expect(presenter.t(:name)).to eq('Non-Translated Work Type')
          end
        end
      end

      context 'for actions' do
        let(:work_presenter) { WorkPresenter.new(work: work, presentation_structure: nil) }
        let(:presenter) { ActionPresenter.new(context: work_presenter, name: action_name) }
        let(:template) do
          view_container = ActionController::Base.new
          view = ActionView::Base.new(view_container.view_paths, {}, view_container, [:html])
        end
        context 'submit actions' do
          let(:action_name) { :create }
          context 'with existing work type translations' do
            let(:work_type) { 'Work Type Translated' }
            it 'renders a submit tag with translation' do
              expect(presenter.render(template: template)).
                to eq('<input name="commit" type="submit" value="Create a Translated Work" />')
            end
          end
          context 'without existing work type translations' do
            let(:work_type) { 'Non-Translated Work Type' }
            it 'renders a submit tag with a default' do
              expect(presenter.render(template: template)).
                to eq('<input name="commit" type="submit" value="Create a Work" />')
            end
          end
        end

        context 'link actions' do
          let(:action_name) { :edit }
          context 'with existing work type translations' do
            let(:work_type) { 'Work Type Translated' }
            it 'renders an a-tag' do
              expect(presenter.render(template: template)).
                to eq(%(<a href="/path/to/edit/#{work.to_param}">Edit Translated Work</a>))
            end
          end
          context 'without existing work type translations' do
            let(:work_type) { 'Non-Translated Work Type' }
            it 'translates its :name by using the key directly' do
              expect(presenter.render(template: template)).
                to eq(%(<a href="/path/to/edit/#{work.to_param}">Edit the Work</a>))
            end
          end
        end
      end

      context 'for property_sets' do
        let(:presenter) { FieldsetPresenter.new(work: work, fieldset: fieldset) }
        context 'with existing property set and work type translations' do
          let(:fieldset) { PropertySet(identity: 'Property Set Translated') }
          let(:work_type) { 'Work Type Translated' }
          it 'translates its :name from the lookup table' do
            expect(presenter.t(:name)).to eq('I Am a Translated Property Set for a Translated Work Type!')
          end
        end
        context 'with existing property set but not work type translations' do
          let(:fieldset) { PropertySet(identity: 'Property Set Translated') }
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name' do
            expect(presenter.t(:name)).to eq('I Am a Translated Property Set with a non-Translated Work Type!')
          end
        end

        context 'without property set translations' do
          let(:fieldset) { PropertySet(identity: 'Non-Translated Property Set') }
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name by using the work type directly' do
            expect(presenter.t(:name)).to eq('Non-Translated Property Set')
          end
        end
      end

      context 'for properties' do
        let(:presenter) { PropertyPresenter.new(work: work, fieldset: fieldset, property: property) }
        context 'with existing property and work type translations' do
          let(:fieldset) { PropertySet(identity: 'Property Set Translated') }
          let(:property) { Property('Property Translated') }
          let(:work_type) { 'Work Type Translated' }
          it 'translates its :name from the lookup table' do
            expect(presenter.t(:name)).to eq('I Am a Translated Property for a Translated Work Type!')
          end
        end
        context 'with existing property but not property set translations' do
          let(:fieldset) { PropertySet(identity: 'Non-Translated Property Set') }
          let(:property) { Property('Property Translated') }
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name' do
            expect(presenter.t(:name)).to eq('I Am a Translated Property with a non-Translated Work Type!')
          end
        end

        context 'without property translations' do
          let(:fieldset) { PropertySet(identity: 'Non-Translated Property Set') }
          let(:property) { Property('Non-Translated Property') }
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name by using the work type directly' do
            expect(presenter.t(:name)).to eq('Non-Translated Property')
          end
        end
      end

      around do |example|
        begin
          # @TODO - The structure of the hash is not ideal. The order of keys is
          # somewhat counter-intuitive.
          old_backend = I18n.backend
          I18n.backend = old_backend.clone
          translations = Psych.load_file(File.expand_path('../../fixtures/translations.yml', __FILE__))
          I18n.backend.store_translations(:en, translations.fetch('en'))
          example.run
        ensure
          I18n.backend = old_backend
        end
      end
    end
  end
end
