require 'spec_active_record_helper'
require 'hydramata/works/database_persister/coordinator'
require 'hydramata/works/works/database_storage'

module Hydramata
  module Works
    describe DatabasePersister::Coordinator do
      subject { described_class }
      let(:attributes) { { pid: '123', work_type: 'Article' } }
      let(:storage) { Works::DatabaseStorage }
      it 'creates a new instance if one does not exist' do
        expect { described_class.call(attributes, storage) }.
          to change { storage.count }.
          by(1)
        expect { described_class.call(attributes, storage) }.
          to_not change { storage.count }
      end

      it 'overwrites the existing work type if one is given' do
        initial_work = described_class.call(attributes)
        expect { described_class.call(attributes.merge(work_type: 'Document')) }.
          to change { storage.find(attributes.fetch(:pid)).work_type }.
          from('Article').
          to('Document')
      end

      it 'updates property keys for matches but ignores misses' do
        initial_work = described_class.call(attributes.merge(properties: { title: 'Hello', subject: 'Trees', locations: 'Here' }))
        expect { described_class.call(attributes.merge(properties: { title: 'World', locations: nil })) }.
          to change { storage.find(attributes.fetch(:pid)).properties }.
          from({ title: 'Hello', subject: 'Trees', locations: 'Here' }).
          to({ title: 'World', subject: 'Trees' })
      end
    end
  end
end
