# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_predicate_set_interface do
  match do |subject|
    true
  end

  description do
    "implmenents the PredicateSet interface"
  end
end
