require 'spec_fast_helper'
require 'hydramata/works/apply_user_input_to_work'

module Hydramata
  module Works
    describe ApplyUserInputToWork do
      let(:work) { double('Work', properties: properties) }
      let(:attributes) { { name: 'John', title: ['Hello', 'World'] } }

      xit 'should shovel predicates and values into the properties' do
        expect { described_class.call(work: work, attributes: attributes) }.
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
