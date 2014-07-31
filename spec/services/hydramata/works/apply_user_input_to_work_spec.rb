require 'spec_fast_helper'
require 'hydramata/works/apply_user_input_to_work'

module Hydramata
  module Works
    describe ApplyUserInputToWork do
      let(:work) { double('Work', :properties => [], :work_type= => true) }
      let(:input) { { work_type: 'shoe', name: 'John', title: ['Hello', 'World'] } }

      context 'assigning work type to the work' do
        it 'based on the :work_type hash key' do
          described_class.call(work: work, input: input)
          expect(work).to have_received(:work_type=).with('shoe')
        end

        it 'and falling back on the "work_type" hash key' do
          input = { 'work_type' => 'shoe' }
          described_class.call(work: work, input: input)
          expect(work).to have_received(:work_type=).with('shoe')
        end

        it 'and raises an error if a work_type cannot be assigned' do
          input = { }
          expect { described_class.call(work: work, input: input) }.to raise_error(KeyError)
        end
      end

      it 'should shovel predicates and values into the properties' do
        expect { described_class.call(work: work, input: input) }.
          to change { work.properties }.
          from([]).
        to(
          [
            { predicate: :name, values: 'John' },
            { predicate: :title, values: ['Hello', 'World'] }
          ]
        )
      end
    end
  end
end
