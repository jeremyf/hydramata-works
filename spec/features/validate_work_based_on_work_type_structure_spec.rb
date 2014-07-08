require 'spec_slow_helper'
module Hydramata
  module Works
    describe 'validate work based on work type structure' do
      let(:predicate) { Predicate.new(identity: 'title', validations: '{"presence": true}') }
      let(:work) do
        Work.new(work_type: 'article') do |work|
          work.properties << Property.new(predicate: predicate, values: [])
        end
      end
      let(:form) { WorkForm.new(work) }

      it 'should enforce validations' do
        expect(form.valid?).to be_falsey
        expect(form.errors.size).to eq(1)
      end
    end
  end
end
