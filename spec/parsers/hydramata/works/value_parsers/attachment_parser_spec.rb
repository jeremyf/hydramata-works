require 'spec_active_record_helper'
require 'spec_file_upload_helper'
require 'hydramata/works/value_parsers/attachment_parser'
require 'hydramata/works/attachments/database_storage'

module Hydramata
  module Works
    module ValueParsers
      describe AttachmentParser do
        context 'file uploaded via UI' do
          let(:object) { FileUpload.fixture_file_upload('attachments/hello-world.txt') }
          it 'grabs the original_filename' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: 'hello-world.txt', raw_object: object)
          end
        end

        context 'file persisted in storage' do
          let(:file) { FileUpload.pathname_for('attachments/hello-world.txt') }
          let(:object) { Attachments::DatabaseStorage.create(file: file, pid: 'a', work_id: 'b', predicate: 'attachment') }
          it 'grabs the original_filename' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: 'hello-world.txt', raw_object: object)
          end
        end

        context 'already parsed object' do
          let(:object) { double('Object', raw_object: :a_raw_object) }
          it 'preserves the already parsed object' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: object, raw_object: object.raw_object)
          end
        end

        context 'an unexpected object' do
          let(:object) { double('Object') }
          it 'preserves the already parsed object' do
            expect { |b| described_class.call(object, &b) }.to yield_with_args(value: object, raw_object: object)
          end
        end
      end
    end
  end
end
