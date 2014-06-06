# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/predicate'
require 'hydramata/work/linters/implement_predicate_interface_matcher'

module Hydramata
  module Work
    describe Predicate do
      subject { described_class.new }
      it { should implement_predicate_interface }

      it 'should initialize via attributes' do
        expect(described_class.new(identity: 'My Identity').identity).to eq('My Identity')
      end

    end
  end
end
