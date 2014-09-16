require 'spec_fast_helper'
require 'hydramata/works/property_presenter_dom_helper'
require 'hydramata/works/work'
require 'hydramata/works/conversions/property'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe PropertyPresenterDomHelper do
      let(:work) { Work.new(work_type: 'a work type') }
      let(:predicate) { Predicate.new(identity: 'my_predicate', validations: { required: true } ) }
      let(:property) { double('property', predicate: predicate, presenter_dom_class: 'property', dom_class: 'my-predicate') }
      subject { described_class.new(property) }

      context 'dom helpers' do
        Then { subject.id_for_field(index: 1) == "work_#{predicate}_1" }
        And { subject.id_for_label == "label_for_work_#{predicate}" }
        And { subject.name_for_field == "work[#{predicate}][]" }
      end

      context '#label_attributes' do
        Given(:options) { { :class => ['123'] } }
        When(:returned_value) { subject.label_attributes(options) }
        Then do
          returned_value == {
            :id=>"label_for_work_my_predicate",
            :class=>["123", "label", "property", 'my-predicate', 'required']
          }
        end
      end

      context '#value_attributes' do
        Given(:options) { { :class => ['123'] } }
        When(:returned_value) { subject.value_attributes(options) }
        Then do
          returned_value == {
            'aria-labelledby'=>"label_for_work_my_predicate",
            :class=>["123", "value", "property", 'my-predicate']
          }
        end
      end
    end
  end
end
