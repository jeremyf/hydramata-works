require 'spec_fast_helper'
require 'hydramata/works/database_persister'

module Hydramata
  module Works
    describe DatabasePersister do
      let(:pid) { 'abc-123' }
      let(:storage_service) { double('Storage Service', call: true) }
      let(:property_1) { double(name: 'Title', values: ['Hello World']) }
      let(:property_2) { double(name: 'Description', values: ['A Brief Description']) }
      let(:pid_minting_service) { double('PID Minting Service', call: pid)}
      let(:work) { double('Work', work_type: 'Article', properties: [property_1, property_2])}

      context '#call' do
        it 'passes along to the underlying storage' do
          expect(work).to receive(:identity=).with(pid)
          described_class.call(work: work, storage_service: storage_service, pid_minting_service: pid_minting_service)
          expect(storage_service).to have_received(:call).with(pid: pid, work_type: 'Article', properties: {'Title' => ['Hello World'], 'Description' => ['A Brief Description']})
        end

        it 'returns true on success' do
          expect(work).to receive(:identity=).with(pid)
          expect(
            described_class.call(
              work: work,
              storage_service: storage_service,
              pid_minting_service: pid_minting_service
            )
          ).to be_truthy
        end

        it 'returns false on failure' do
          expect(work).to_not receive(:identity=)
          expect(storage_service).to receive(:call).and_return(false)
          expect(
            described_class.call(
              work: work,
              storage_service: storage_service,
              pid_minting_service: pid_minting_service
            )
          ).to be_falsey
        end
      end
    end
  end
end
