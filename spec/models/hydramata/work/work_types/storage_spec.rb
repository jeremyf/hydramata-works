# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/work_types/storage'
require 'hydramata/work/linters/implement_work_type_interface_matcher'

module Hydramata
  module Work
    module WorkTypes

      describe Storage do
        subject { described_class.new }
        it { should implement_work_type_interface }

        let(:identity) { 'http://hello.com/world' }
        let(:work_type) do
          described_class.create(
            identity: identity,
            name_for_application_usage: 'hello_world'
          )
        end

        context '.find_by_identity' do

          it 'returns a WorkType object when identity exists' do
            work_type # creating the object
            expect(described_class.find_by_identity!(identity)).to implement_work_type_interface
          end

          it 'returns nil when identity is missing' do
            # @TODO - Should this be a NullPredicate?
            expect { described_class.find_by_identity!(identity) }.to raise_error
          end
        end

        context '.existing_attributes_for' do
          it 'should return the existing work_type attributes' do
            work_type
            keys = [
              :id,
              :identity,
              :name_for_application_usage
            ]
            actual_values = described_class.existing_attributes_for(identity).values_at(keys)
            # Because date comparisons are a bit wonky
            expect(actual_values).to eq(work_type.attributes.values_at(keys))
          end

          it 'should return the identity if a matching work_type was not found' do
            expect(described_class.existing_attributes_for(identity)).to eq(identity: identity)
          end

          it 'should handle connection failed' do
            expect(described_class).to receive(:find_by_identity!).and_raise(ActiveRecord::ConnectionNotEstablished)
            expect(described_class.existing_attributes_for(identity)).to eq(identity: identity)
          end
        end

      end
    end
  end
end
