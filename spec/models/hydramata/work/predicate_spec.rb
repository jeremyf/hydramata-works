require 'active_record_spec_helper'
require 'hydramata/work/predicate'

module Hydramata
  module Work
    describe Predicate do
      subject { described_class.new }

      it { should respond_to :name }
      it { should respond_to :uri }
      it { should respond_to :default_datastream_name }
      it { should respond_to :default_coercer_class_name }
      it { should respond_to :default_parser_class_name }
      it { should respond_to :default_indexing_strategy }
    end
  end
end
