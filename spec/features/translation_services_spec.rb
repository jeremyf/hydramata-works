require 'feature_helper'

module Hydramata
  module Work
    describe 'translation services' do
      let(:entity) { Entity.new.tap {|e| e.work_type = work_type } }


      context 'for entities' do
        let(:presenter) { EntityPresenter.new(entity: entity, presentation_structure: nil) }
        context 'with translated work type' do
          let(:work_type) { 'Translated Work Type' }
          it 'translates its :name' do
            expect(presenter.t(:name)).to eq('I Am a Translated Work Type!')
          end
        end
        context 'without translated work type' do
          let(:work_type) { 'Non-Translated Work Type' }
          it 'translates its :name' do
            expect(presenter.t(:name)).to eq('Non-Translated Work Type')
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
