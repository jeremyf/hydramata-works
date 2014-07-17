require 'spec_fast_helper'
require 'hydramata/works/solr_wrangler'
require 'hydramata/works/work'

module Hydramata
  module Works
    describe SolrWrangler do
      let(:work) { Work.new }
      subject { described_class.new(document: document, work: work) }

      it 'assigns the work type to the collaborating work' do
        subject.call
        expect(work.work_type.to_s).to eq('SeniorThesis')
      end

      it 'assigns the identity to the collaborating work' do
        subject.call
        expect(work.identity).to eq('the_namespace:the_noid')
      end

      it 'assigns a predicate to the collaborating work' do
        subject.call
        expect(work.properties[:language].values).to eq(['English'])
      end

      it 'assigns a predicate only once to the collaborating work' do
        subject.call
        expect(work.properties[:title].values).to eq(['Title 1'])
      end

      it 'skips non_metadata attributes' do
        subject.call
        expect { work.properties.fetch(:read_access_group) }.to raise_error
      end

      let(:document) {
        {
          'system_create_dtsi'=>'2014-07-17T15:37:51Z',
          'system_modified_dtsi'=>'2014-07-17T15:37:53Z',
          'object_state_ssi'=>'A',
          'active_fedora_model_ssi'=>'SeniorThesis',
          'id'=>'the_namespace:the_noid',
          'depositor_tesim'=>['username-1'],
          'read_access_group_ssim'=>['registered'],
          'edit_access_person_ssim'=>['username-1'],
          'desc_metadata__language_tesim'=>['English'],
          'desc_metadata__publisher_tesim'=>['University of Notre Dame'],
          'desc_metadata__publisher_ssm'=>['University of Notre Dame'],
          'desc_metadata__title_tesim'=>['Title 1'],
          'desc_metadata__title_ssm'=>['Title 1'],
          'desc_metadata__date_uploaded_dtsim'=>['2014-07-17T00:00:00Z'],
          'desc_metadata__date_uploaded_ssm'=>['2014-07-17'],
          'desc_metadata__date_modified_dtsim'=>['2014-07-17T00:00:00Z'],
          'desc_metadata__date_modified_ssm'=>['2014-07-17'],
          'desc_metadata__rights_tesim'=>['Attribution 3.0 United States'],
          'desc_metadata__rights_ssm'=>['Attribution 3.0 United States'],
          'desc_metadata__creator_tesim'=>['Creator Name1'],
          'desc_metadata__creator_ssm'=>['Creator Name1'],
          'desc_metadata__description_tesim'=>['Hello World!'],
          'desc_metadata__description_ssm'=>['Hello World!'],
          'has_model_ssim'=>['info:fedora/afmodel:SeniorThesis'],
          'human_readable_type_tesim'=>['Senior Thesis'],
          'noid_tsi'=>'the_noid',
          'date_created_derived_dtsim'=>['2014-07-17T00:00:00Z'],
          'timestamp'=>'2014-07-17T15:37:53.181Z'
        }
      }
    end
  end
end
