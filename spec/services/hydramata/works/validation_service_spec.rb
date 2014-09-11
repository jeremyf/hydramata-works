require 'spec_fast_helper'
require 'hydramata/works/validation_service'
require 'hydramata/works/work_form_presenter'
require 'hydramata/works/predicate'
require 'hydramata/works/work'
require 'active_model/validations/presence'

module Hydramata
  module Works
    describe ValidationService do
      let(:title) { nil }
      let(:title_predicate) { Predicate.new(identity: 'title', validations: { presence: true }) }
      let(:work) do
        Work.new(work_type: 'article') do |work|
          work.properties << { predicate: title_predicate }
        end
      end
      let(:work_form) { WorkForm.new(work) }
      subject { described_class }

      context '#call' do
        it 'runs validations attached to each predicate' do
          expect { subject.call(work_form) }.
            to change { work_form.errors.full_messages }.
            from([]).
            to(['title can\'t be blank'])
        end

      end
    end
  end
end
