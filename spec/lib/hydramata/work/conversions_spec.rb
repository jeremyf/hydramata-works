require 'feature_helper'
require 'hydramata/work/conversions'
require 'hydramata/work/linters/implement_predicate_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Predicate' do
        it 'should convert a String to a Predicate object' do
          expect(Predicate('hello')).to implement_predicate_interface
        end

        it 'should convert a Symbol to a Predicate object' do
          expect(Predicate(:hello)).to implement_predicate_interface
        end

        it 'should return the same predicate if a Predicate is given' do
          predicate = Predicate(:hello)
          expect(predicate.object_id).to eq(predicate.object_id)
        end

        it 'should convert a "well-formed" Hash to a Predicate object' do
          expect(Predicate(identity: 'hello')).to implement_predicate_interface
        end

        it 'should raise an error if the Hash is not "well-formed"' do
          expect { Predicate(other: 'hello') }.to raise_error
        end

        it 'should raise an error object is unexpected' do
          expect { Predicate([]) }.to raise_error
        end
      end

      context '#Property' do
        it 'should convert a Hash to a property' do
          expect(Property(predicate: 'a predicate')).to be_an_instance_of(Property)
        end

        it 'should preserve a Property' do
          property = Property.new(predicate: 'a predicate')
          expect(Property(property).object_id).to eq(property.object_id)
        end
      end

      context '#PresentedFieldsets' do
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

        it 'should munge together the presentation structure and entity' do
          presented_fieldsets = PresentedFieldsets(entity: entity, presentation_structure: presentation_structure)

          expect(presented_fieldsets.count).to eq(2)

          required_fieldset = presented_fieldsets[0]
          expect(required_fieldset.entity).to eq(entity)
          expect(required_fieldset.count).to eq(1)
          expect(required_fieldset.name).to eq(:required)
          expect(required_fieldset[:title].values).to eq(['Hello', 'World', 'Bang!'])

          optional_fieldset = presented_fieldsets[1]
          expect(optional_fieldset.entity).to eq(entity)
          expect(optional_fieldset.count).to eq(2)
          expect(optional_fieldset.name).to eq(:optional)
          expect(optional_fieldset[:abstract].values).to eq(['Long Text', 'Longer Text'])
          expect(optional_fieldset[:keyword].values).to eq(['Programming'])
        end
      end
    end
  end
end
