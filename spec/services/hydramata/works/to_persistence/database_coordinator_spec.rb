require 'spec_active_record_helper'
require 'hydramata/works/to_persistence/database_coordinator'
require 'hydramata/works/persisted_works/database_storage'
require 'hydramata/works/attachments/database_storage'

module Hydramata
  module Works
    describe ToPersistence::DatabaseCoordinator do
      subject { described_class }
      let(:attributes) { { pid: '123', work_type: 'Article' } }
      let(:work_storage) { PersistedWorks::DatabaseStorage }
      let(:attachment_storage) { Attachments::DatabaseStorage }
      let(:persisted_attachment) { attachment_storage.new(pid: '1234') }
      let(:my_attachments) do
        {
          predicate_name: [
            File.new(__FILE__)
          ],
          another_predicate_name: [
            File.new(__FILE__),
            persisted_attachment
          ]
        }
      end
      let(:work) { work_storage.find(attributes.fetch(:pid)) }

      it 'creates a new work instance if one does not exist' do
        expect { described_class.call(attributes) }.
          to change { work_storage.count }.
          by(1)
        expect { described_class.call(attributes) }.
          to_not change { work_storage.count }
      end

      it 'overwrites the existing work type if one is given' do
        described_class.call(attributes)
        expect { described_class.call(attributes.merge(work_type: 'Document')) }.
          to change { work.reload.work_type }.
          from('Article').
          to('Document')
      end

      it 'attaches files when attachments are given' do
        pid_minting_service = double
        allow(persisted_attachment).to receive(:persisted?).and_return(true)
        expect(pid_minting_service).to receive(:call).exactly(2).times.and_return('abc', 'efg')
        expect { described_class.call(attributes.merge(attachments: my_attachments), { pid_minting_service: pid_minting_service } ) }.
          to change { attachment_storage.count }.
          by(my_attachments.size)
      end

      it 'updates property keys for matches but ignores misses' do
        described_class.call(attributes.merge(properties: { title: 'Hello', subject: 'Trees', locations: 'Here' }))
        expect { described_class.call(attributes.merge(properties: { title: 'World', locations: nil })) }.
          to change { work.reload.properties }.
          from({ 'title' => 'Hello', 'subject' => 'Trees', 'locations' => 'Here' }).
          to({ 'title' => 'World', 'subject' => 'Trees' })
      end
    end
  end
end
