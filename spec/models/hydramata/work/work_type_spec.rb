# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'

module Hydramata
  module Work
    describe WorkType do
      subject { described_class.new }
      it { should implement_work_type_interface }

      it 'should initialize via attributes' do
        expect(described_class.new(identity: 'My Identity').identity).to eq('My Identity')
      end

    end
  end
end
