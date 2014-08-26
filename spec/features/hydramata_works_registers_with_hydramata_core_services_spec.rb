require 'spec_slow_helper'
require 'hydramata-core'

module Hydramata
  module Works
    describe 'plugs into Hydramata::Services' do
      it 'appends the service repository methods' do
        expect(Hydramata::Services.included_modules).to include(::Hydramata::Works::ServiceMethods)
      end
    end
  end
end

