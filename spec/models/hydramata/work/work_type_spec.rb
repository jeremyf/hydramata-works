# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe WorkType do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_work_type_interface }
      it { should implement_data_definition_interface }

    end
  end
end
