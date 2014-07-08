require 'spec_fast_helper'
require 'hydramata/works/work_types'
require 'hydramata/works/linters/implement_work_type_interface_matcher'


module Hydramata
  module Works
    describe WorkTypes do
      context '.find' do
        it 'uses the identity to construct the appropriate work_type' do
          expect(described_class.find('name', { something: 'george' })).to implement_work_type_interface
        end
      end
    end
  end
end
