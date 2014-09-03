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

        context '.find_or_create_by_pid' do
          let(:pid) { '123' }
          it 'creates a new instance if one does not exist' do
            expect { described_class.find_or_create_by_pid(pid: pid, work_type: 'Article') }.
              to change { described_class.count }.
              by(1)
            expect { described_class.find_or_create_by_pid(pid: pid, work_type: 'Article') }.
              to_not change { described_class.count }
          end

          it 'overwrites the existing work type if one is given' do
            initial_work = described_class.find_or_create_by_pid(pid: pid, work_type: 'Article')
            expect { described_class.find_or_create_by_pid(pid: pid, work_type: 'Document') }.
              to change { described_class.find(pid).work_type }.
              from('Article').
              to('Document')
          end

          it 'updates property keys for matches but ignores misses' do
            initial_work = described_class.find_or_create_by_pid(pid: pid, work_type: 'Article', properties: { title: 'Hello', subject: 'Trees', locations: 'Here' })
            expect { described_class.find_or_create_by_pid(pid: pid, properties: { title: 'World', locations: nil }) }.
              to change { described_class.find(pid).properties }.
              from({ title: 'Hello', subject: 'Trees', locations: 'Here' }).
              to({ title: 'World', subject: 'Trees' })
          end
        end
      end
    end
  end
end
