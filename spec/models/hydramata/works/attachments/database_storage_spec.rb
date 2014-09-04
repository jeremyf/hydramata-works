require 'spec_active_record_helper'
require 'hydramata/works/attachments/database_storage'

module Hydramata
  module Works
    module Attachments
      describe DatabaseStorage do
        subject { described_class.new }

        it 'has an attachment via the dragonfly gem' do
          subject.attachment = File.new(__FILE__)
          expect(subject.attachment.data).to eq(File.read(__FILE__))
        end
      end
    end
  end
end