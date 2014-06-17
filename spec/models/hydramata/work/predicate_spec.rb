# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/predicate'
require 'hydramata/work/linters/implement_predicate_interface_matcher'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe Predicate do
      subject { described_class.new }
      it { should implement_predicate_interface }
      it { should implement_data_definition_interface }

      it { should respond_to(:name_for_application_usage) }
      it { should respond_to(:datastream_name) }
      it { should respond_to(:value_coercer_name) }
      it { should respond_to(:value_parser_name) }
      it { should respond_to(:indexing_strategy) }

      it { should respond_to(:name_for_application_usage=) }
      it { should respond_to(:datastream_name=) }
      it { should respond_to(:value_coercer_name=) }
      it { should respond_to(:value_parser_name=) }
      it { should respond_to(:indexing_strategy=) }

    end
  end
end
