require 'spec_slow_helper'
require 'hydramata-core'

module Hydramata
  module Works
    describe 'plugs into Hydramata::Core::Services' do
      it 'appends the service repository methods' do
        expect(Hydramata::Core::Services.included_modules).to include(ServiceRepositoryMethods)
      end
    end
  end
end

