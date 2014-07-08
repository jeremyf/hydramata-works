require 'spec_fast_helper'
require 'hydramata/works/work'
require 'hydramata/works/presentation_structure'
require 'hydramata/works/conversions/presented_fieldsets'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#PresentedFieldsets' do
        let(:work) do
          Work.new.tap do |work|
            work.work_type = 'Hello'
            work.properties << { predicate: :title, value: 'Hello' }
            work.properties << { predicate: :title, value: 'World' }
            work.properties << { predicate: :title, value: 'Bang!' }
            work.properties << { predicate: :abstract, value: 'Long Text' }
            work.properties << { predicate: :abstract, value: 'Longer Text' }
            work.properties << { predicate: :keyword, value: 'Programming' }
          end
        end

        let(:presentation_structure) do
          PresentationStructure.new.tap do |struct|
            struct.fieldsets << [:required, [:title]]
            struct.fieldsets << [:optional, [:abstract, :keyword]]
          end
        end

        it 'should munge together the presentation structure and work' do
          presented_fieldsets = PresentedFieldsets(work: work, presentation_structure: presentation_structure)

          expect(presented_fieldsets.count).to eq(2)

          required_fieldset = presented_fieldsets[0]
          expect(required_fieldset.work).to eq(work)
          expect(required_fieldset.count).to eq(1)
          expect(required_fieldset.name.to_s).to eq('required')
          expect(required_fieldset[:title].values).to eq(['Hello', 'World', 'Bang!'])

          optional_fieldset = presented_fieldsets[1]
          expect(optional_fieldset.work).to eq(work)
          expect(optional_fieldset.count).to eq(2)
          expect(optional_fieldset.name.to_s).to eq('optional')
          expect(optional_fieldset[:abstract].values).to eq(['Long Text', 'Longer Text'])
          expect(optional_fieldset[:keyword].values).to eq(['Programming'])
        end
      end
    end
  end
end
