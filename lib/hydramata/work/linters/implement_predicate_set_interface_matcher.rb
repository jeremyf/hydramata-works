# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_predicate_set_interface do
  match do |subject|
    [:work_type, :identity, :presentation_sequence, :name_for_application_usage, :predicates].all? do |method_name|
      subject.respond_to?(method_name)
    end
  end

  description do
    "implmenents the PredicateSet interface"
  end
end
