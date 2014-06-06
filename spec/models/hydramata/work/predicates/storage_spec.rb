# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/predicates/storage'
require 'hydramata/work/linters/implement_predicate_interface_matcher'

module Hydramata
  module Work
    module Predicates

      describe Storage do
        subject { described_class.new }
        it { should implement_predicate_interface }

        context '.find_by_identity' do
          let(:identity) { 'http://hello.com/world' }
          it 'returns a Predicate object when identity exists' do
            predicate = described_class.create(
              identity: identity,
              name_for_application_usage: 'hello-world',
              default_datastream_name: 'descMetadata',
              default_coercer_class_name: 'SimpleParser',
              default_parser_class_name: 'SimpleParser',
              default_indexing_strategy: 'dsti'
            )

            expect(described_class.find_by_identity(identity)).to implement_predicate_interface
          end

          it 'returns nil when identity is missing' do
            # @TODO - Should this be a NullPredicate?
            expect(described_class.find_by_identity(identity)).to be_nil
          end
        end

      end
    end
  end
end
