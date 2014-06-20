require 'spec_fast_helper'
require 'hydramata/work/entity'
require 'hydramata/work/presentation_structure'
require 'hydramata/work/conversions/presented_fieldsets'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#PresentedFieldsets' do
        let(:entity) do
          Entity.new.tap do |entity|
            entity.work_type = 'Hello'
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

        it 'should munge together the presentation structure and entity' do
          presented_fieldsets = PresentedFieldsets(entity: entity, presentation_structure: presentation_structure)

          expect(presented_fieldsets.count).to eq(2)

          required_fieldset = presented_fieldsets[0]
          expect(required_fieldset.entity).to eq(entity)
          expect(required_fieldset.count).to eq(1)
          expect(required_fieldset.name.to_s).to eq('required')
          expect(required_fieldset[:title].values).to eq(['Hello', 'World', 'Bang!'])

          optional_fieldset = presented_fieldsets[1]
          expect(optional_fieldset.entity).to eq(entity)
          expect(optional_fieldset.count).to eq(2)
          expect(optional_fieldset.name.to_s).to eq('optional')
          expect(optional_fieldset[:abstract].values).to eq(['Long Text', 'Longer Text'])
          expect(optional_fieldset[:keyword].values).to eq(['Programming'])
        end
      end
    end
  end
end
