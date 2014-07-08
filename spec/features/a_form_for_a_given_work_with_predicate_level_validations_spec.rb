require 'spec_fast_helper'
require 'hydramata/works/predicate'
require 'hydramata/works/property'
require 'hydramata/works/work'
require 'hydramata/works/work_form'

module Hydramata
  module Works
    describe 'a form for a given work with predicate level validations' do
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
        expect(form.errors[:title]).to eq(["can't be blank"])
      end
    end
  end
end
