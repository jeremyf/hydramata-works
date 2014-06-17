# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_property_set_interface do
  match do |subject|
    [:<<, :[], :predicates, :fetch, :==, :each, :subset].all? do |method_name|
      subject.respond_to?(method_name)
    end
  end

  description do
    "implmenents the PropertySet interface"
  end
end
