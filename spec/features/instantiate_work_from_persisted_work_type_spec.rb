require 'spec_active_record_helper'
require 'hydramata/works/property'
require 'hydramata/works/work'
require 'hydramata/works/work_type'

module Hydramata
  module Works
    describe 'Instantiating a work from a persisted work type' do
      include Conversions
      before(:each) do
        load File.expand_path('../../support/feature_seeds.rb', __FILE__)
      end

      let(:property) { Property.new(predicate: 'dc_title', values: ['Hello', 'World']) }
      let(:work) do
        Work.new(work_type: 'article') do |work|
          work.properties << property
        end
      end

      it 'assigns a work type' do
        expect(work.work_type).to eq(WorkType.new(identity: 'article'))
      end

      it 'retrieves, via a predicate, the property and values that were set' do
        expect(work.properties[:dc_title].values).to eq(['Hello', 'World'])
      end
    end
  end
end
