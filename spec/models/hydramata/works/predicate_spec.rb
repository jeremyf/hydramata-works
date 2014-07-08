# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/predicate'
require 'hydramata/works/linters/implement_predicate_interface_matcher'
require 'hydramata/works/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Works
    describe Predicate do
      subject { described_class.new }
      it { should implement_predicate_interface }
      it { should implement_data_definition_interface }
    end
  end
end
