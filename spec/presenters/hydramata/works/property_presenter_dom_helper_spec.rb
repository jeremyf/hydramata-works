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

      context '#label_attributes' do
        it 'handles a :suffix' do
          expect(subject.label_attributes(suffix: 'hello')).
            to eq({:id=>"label_for_work_my_predicate_hello", :class=>["label", "property", "my-predicate", "required"]})
        end

        it 'handles an :index' do
          expect(subject.label_attributes(index: 1, suffix: 'hello')).
            to eq({:id=>"label_for_work_my_predicate_hello_1", :class=>["label", "property", "my-predicate", "required"]})
        end

        it 'has a default' do
          expect(subject.label_attributes).
            to eq({:id=>"label_for_work_my_predicate", :class=>["label", "property", "my-predicate", "required"]})
        end

        it 'merges attributes' do
          expect(subject.label_attributes(:id => 'override_id', :class => 'another_class', 'data-attribute' => 'a data attribute')).
            to eq({:id=>"override_id", :class=>["another_class", "label", "property", "my-predicate", "required"], 'data-attribute' => 'a data attribute'})
        end
      end

      context '#value_attributes' do
        it 'handles a :suffix' do
          expect(subject.value_attributes(suffix: 'hello')).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate_hello", :class=>["value", "property", "my-predicate"]})
        end

        it 'handles an :index' do
          expect(subject.value_attributes(index: 1, suffix: 'hello')).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate_hello_1", :class=>["value", "property", "my-predicate"]})
        end

        it 'has a default' do
          expect(subject.value_attributes).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate", :class=>["value", "property", "my-predicate"]})
        end

        it 'merges attributes' do
          expect(subject.value_attributes('aria-labelledby' => 'override_id', :class => 'another_class', 'data-attribute' => 'a data attribute')).
            to eq({'aria-labelledby'=>"override_id", :class=>["another_class", "value", "property", "my-predicate"], 'data-attribute' => 'a data attribute'})
        end
      end

      context '#input_attributes' do
        it 'handles a :suffix' do
          expect(subject.input_attributes(suffix: 'hello')).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate_hello", :class=>["value", "property", "my-predicate"], :name => "work[my_predicate][hello][]", :required => 'required'})
        end

        it 'handles an :index' do
          expect(subject.input_attributes(index: 1, suffix: 'hello')).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate_hello_1", :class=>["value", "property", "my-predicate"], :name => "work[my_predicate][hello][]", :required => 'required'})
        end

        it 'has a default' do
          expect(subject.input_attributes).
            to eq({'aria-labelledby'=>"label_for_work_my_predicate", :class=>["value", "property", "my-predicate"], :name => "work[my_predicate][]", :required => 'required'})
        end

        it 'merges attributes' do
          expect(subject.input_attributes('aria-labelledby' => 'override_id', :class => 'another_class', 'data-attribute' => 'a data attribute')).
            to eq({'aria-labelledby'=>"override_id", :class=>["another_class", "value", "property", "my-predicate"], :name => "work[my_predicate][]", 'data-attribute' => 'a data attribute', :required => 'required'})
        end
      end

    end
  end
end
