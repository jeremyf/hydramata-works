require 'spec_active_record_helper'
require 'hydramata/works/attachments/database_storage'

module Hydramata
  module Works
    module Attachments
      describe DatabaseStorage do
        subject { described_class.new }

        it 'has an file via the dragonfly gem' do
          subject.file = File.new(__FILE__)
          expect(subject.file.data).to eq(File.read(__FILE__))
        end

        it 'has an file via the dragonfly gem' do
          subject.file = File.new(__FILE__)
          expect(subject.file_name).to eq(File.basename(__FILE__))
        end
      end
    end
  end
end