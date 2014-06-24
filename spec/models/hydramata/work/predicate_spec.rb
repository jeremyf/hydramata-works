# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/work/predicate'
require 'hydramata/work/linters/implement_predicate_interface_matcher'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe Predicate do
      subject { described_class.new }
      it { should implement_predicate_interface }
      it { should implement_data_definition_interface }
    end
  end
end
