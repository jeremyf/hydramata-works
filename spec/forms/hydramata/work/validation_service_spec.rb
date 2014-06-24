require 'spec_fast_helper'
require 'hydramata/work/validation_service'
require 'hydramata/work/entity_form'
require 'hydramata/work/predicate'
require 'hydramata/work/entity'
require 'active_model/validations/presence'

module Hydramata
  module Work
    describe ValidationService do
      let(:title) { nil }
      let(:title_predicate) { Predicate.new(identity: 'title') }
      let(:entity) do
        Entity.new(work_type: 'article') do |entity|
          entity.properties << { predicate: title_predicate }
        end
      end
      let(:predicates_with_validations) { [ [:title, { presence: true } ] ] }
      let(:entity_form) { EntityForm.new(entity) }
      subject { described_class }

      context '#call' do
        it 'runs validations attached to each predicate' do
          expect(entity_form).to receive(:predicates_with_validations).and_return(predicates_with_validations)
          expect { subject.call(entity_form) }.
            to change { entity_form.errors.full_messages }.
            from([]).
            to(['title can\'t be blank'])
        end

        it 'returns nil regardless of errors' do
          expect(entity_form).to receive(:predicates_with_validations).and_return([])
          expect(subject.call(entity_form)).to be_nil
        end

      end
    end
  end
end
