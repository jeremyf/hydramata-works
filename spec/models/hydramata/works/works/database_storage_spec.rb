# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_active_record_helper'
require 'hydramata/works/works/database_storage'
require 'hydramata/works/linters/implement_work_interface_matcher'

module Hydramata
  module Works
    module Works
      describe DatabaseStorage do
        let(:attributes) { { pid: '123', work_type: 'Article', properties: {} } }
        subject { described_class.new(attributes) }

        it 'saves the object' do
          expect { subject.save! }.
            to change { described_class.count }.
            by(1)
        end

        it 'should implement #to_work' do
          expect(subject.to_work).to implement_work_interface.with(:state, 'unknown')
        end

      end
    end
  end
end
