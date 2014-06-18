require 'feature_helper'
require 'hydramata/work/conversions/property_set'
require 'hydramata/work/conversions/property'

module Hydramata
  module Work
    describe 'translation services' do
      include Conversions
      let(:entity) { Entity.new.tap {|e| e.work_type = work_type } }

      context 'for entities' do
        let(:presenter) { EntityPresenter.new(entity: entity, presentation_structure: nil) }
        context 'with existing work type translations' do
          let(:work_type) { 'Work Type Translated' }
          it 'translates its :name from the lookup table' do
            expect(presenter.t(:name)).to eq('I Am a Translated Work Type!')
          end
        end
        context 'without existing work type translations' do
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name by using the work type directly' do
            expect(presenter.t(:name)).to eq('Non-Translated Work Type')
          end
        end
      end

      context 'for property_sets' do
        let(:presenter) { FieldsetPresenter.new(entity: entity, fieldset: fieldset) }
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

      context 'for properts' do
        let(:presenter) { PropertyPresenter.new(entity: entity, fieldset: fieldset, property: property) }
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
