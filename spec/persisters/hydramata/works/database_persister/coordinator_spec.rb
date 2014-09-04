require 'spec_active_record_helper'
require 'hydramata/works/database_persister/coordinator'
require 'hydramata/works/works/database_storage'

module Hydramata
  module Works
    describe DatabasePersister::Coordinator do
      subject { described_class }
      let(:attributes) { { pid: '123', work_type: 'Article' } }
      let(:storage) { Works::DatabaseStorage }
      let(:attachment_storage) { double }
      let(:my_attachments) { { predicate_name: [:first_file, :second_file] } }
      let(:work) { storage.find(attributes.fetch(:pid)) }
      it 'creates a new instance if one does not exist' do
        expect { described_class.call(attributes) }.
          to change { storage.count }.
          by(1)
        expect { described_class.call(attributes) }.
          to_not change { storage.count }
      end

      it 'overwrites the existing work type if one is given' do
        described_class.call(attributes)
        expect { described_class.call(attributes.merge(work_type: 'Document')) }.
          to change { work.reload.work_type }.
          from('Article').
          to('Document')
      end

      it 'attaches attachments when attachments are given' do
        pid_minting_service = double
        expect(pid_minting_service).to receive(:call).exactly(2).times.and_return('abc', 'efg')
        expect(attachment_storage).
          to receive(:create!).
          with(pid: 'abc', work_id: attributes.fetch(:pid), predicate: :predicate_name, attachment: :first_file ).
          and_return(true)
        expect(attachment_storage).
          to receive(:create!).
          with(pid: 'efg', work_id: attributes.fetch(:pid), predicate: :predicate_name, attachment: :second_file ).
          and_return(true)
        described_class.call(attributes.merge(attachments: my_attachments), { pid_minting_service: pid_minting_service, attachment_storage: attachment_storage })
      end

      it 'updates property keys for matches but ignores misses' do
        described_class.call(attributes.merge(properties: { title: 'Hello', subject: 'Trees', locations: 'Here' }))
        expect { described_class.call(attributes.merge(properties: { title: 'World', locations: nil })) }.
          to change { work.reload.properties }.
          from({ title: 'Hello', subject: 'Trees', locations: 'Here' }).
          to({ title: 'World', subject: 'Trees' })
      end
    end
  end
end
