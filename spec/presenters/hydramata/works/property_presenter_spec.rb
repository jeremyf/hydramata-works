require 'spec_fast_helper'
require 'hydramata/works/property_presenter'
require 'hydramata/works/work'
require 'hydramata/works/conversions/property'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe PropertyPresenter do
      include Conversions
      let(:work) { Work.new(work_type: 'a work type') }
      let(:predicate) { Predicate.new(identity: 'my_predicate', validations: { required: true } ) }
      let(:property) { Property(predicate: predicate) }
      let(:renderer) { double('Renderer', call: true) }
      subject { described_class.new(property: property, work: work, renderer: renderer) }

      it 'delegates render to the renderer' do
        template = double
        expect(renderer).to receive(:call).with(template: template).and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['a_work_type','my_predicate'], ['my_predicate']])
      end

      context 'dom helpers' do
        Then { subject.dom_id_for_field(index: 1) == "work_#{predicate}_1" }
        And { subject.dom_id_for_label == "label_for_work_#{predicate}" }
        And { subject.dom_name_for_field == "work[#{predicate}][]" }
      end

      context '#dom_label_attributes' do
        Given(:options) { { :class => ['123'] } }
        When(:returned_value) { subject.dom_label_attributes(options) }
        Then do
          returned_value == {
            :id=>"label_for_work_my_predicate",
            :class=>["123", "label", "property", 'my-predicate', 'required']
          }
        end
      end

      context '#dom_value_attributes' do
        Given(:options) { { :class => ['123'] } }
        When(:returned_value) { subject.dom_value_attributes(options) }
        Then do
          returned_value == {
            'aria-labelledby'=>"label_for_work_my_predicate",
            :class=>["123", "value", "property", 'my-predicate'],
            :required=>'required'
          }
        end
      end
    end
  end
end
