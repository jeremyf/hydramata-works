require 'spec_fast_helper'
require 'hydramata/works/fedora_wrangler'

module Hydramata
  module Works
    class MockWork
      attr_accessor :work_type
    end
    describe FedoraWrangler do
      let(:model_name) { 'SeniorThesis' }
      let(:digital_object) { double('Digital Object', models: ["info:fedora/afmodel:#{model_name}", 'info:fedora/fedora-system:FedoraObject-3.0'])}
      let(:repository_connection) { double('Repository Connection', find: true) }
      let(:work) { MockWork.new }
      subject { described_class.new(repository_connection: repository_connection, work: work) }

      it 'assigns the work type to the collaborating work' do
        expect(repository_connection).to receive(:find).and_return(digital_object)
        expect { subject.call(:pid) }.
          to change { work.work_type }.
          from(nil).
          to('SeniorThesis')
      end

    end
  end
end
