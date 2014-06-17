# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_value_interface do

  match do |subject|
    subject.respond_to?(:raw_object)
  end

  description { 'implemenents the Value interface' }
end
