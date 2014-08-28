# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/predicates/storage'
require 'hydramata/works/linters/implement_predicate_interface_matcher'

module Hydramata
  module Works
    module Predicates

      describe Storage do
        subject { described_class.new }

        let(:identity) { 'http://hello.com/world' }
        let(:name_for_application_usage) { 'hello-world' }
        let(:predicate) do
          described_class.create(
            identity: identity,
            name_for_application_usage: name_for_application_usage,
            datastream_name: 'descMetadata',
            value_coercer_name: 'SimpleParser',
            value_parser_name: 'SimpleParser',
            indexing_strategy: 'dsti',
            validations: '{ "presence": { "on": "create" } }'
          )
        end

        it { should implement_predicate_interface }

        context '#to_predicate' do
          it 'coerces itself to a predicate' do
            expect(described_class.new.to_predicate).to implement_predicate_interface
          end
        end

        context '.find_by_identity!' do

          it 'returns a Predicate object when identity exists' do
            predicate # creating the object
            expect(described_class.find_by_identity!(identity)).to implement_predicate_interface
          end

          it 'returns a Predicate object when finding by name_for_application_usage' do
            predicate # creating the object
            expect(described_class.find_by_identity!(name_for_application_usage)).to implement_predicate_interface
          end

          it 'returns nil when identity is missing' do
            # @TODO - Should this be a NullPredicate?
            expect { described_class.find_by_identity!(identity) }.to raise_error
          end
        end

        context '.existing_attributes_for' do
          it 'returns the existing predicate attributes' do
            predicate
            keys = [
              :id,
              :identity,
              :name_for_application_usage,
              :datastream_name,
              :value_coercer_name,
              :value_parser_name,
              :indexing_strategy
            ]
            actual_values = described_class.existing_attributes_for(identity).values_at(keys)
            # Because date comparisons are a bit wonky
            expect(actual_values).to eq(predicate.attributes.values_at(keys))
          end

          it 'returns the identity if a matching predicate was not found' do
            expect(described_class.existing_attributes_for(identity)).to eq(identity: identity)
          end

          it 'handles connection failed' do
            expect(described_class).to receive(:find_by_identity!).and_raise(ActiveRecord::ConnectionNotEstablished)
            expect(described_class.existing_attributes_for(identity)).to eq(identity: identity)
          end

          it 'has many work types' do
            expect(subject.work_types).to eq([])
          end

          it 'has many predicate_sets' do
            expect(subject.predicate_sets).to eq([])
          end

          it 'has many predicate_set_presentations' do
            expect(subject.predicate_set_presentations).to eq([])
          end

        end

      end
    end
  end
end
