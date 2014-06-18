# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe WorkType do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_work_type_interface }
      it { should implement_data_definition_interface }

      context '#name_for_application_usage' do
        it 'should default to identity if no name is given for application usage' do
          expect(subject.name_for_application_usage).to eq subject.identity
        end
        it 'should default to identity if no name is given for application usage' do
          subject = described_class.new(identity: 'My Identity', name_for_application_usage: 'Twonky')
          expect(subject.name_for_application_usage).to eq 'Twonky'
        end
      end

      it { should respond_to(:name_for_application_usage) }
      it { should respond_to(:name_for_application_usage=) }
    end
  end
end
