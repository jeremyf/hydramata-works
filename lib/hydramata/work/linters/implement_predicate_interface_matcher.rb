# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_predicate_interface do
  PREDICATE_INTERFACE_METHODS = [
    :identity,
    :name_for_application_usage,
    :datastream_name,
    :value_coercer_name,
    :value_parser_name,
    :indexing_strategy
  ].freeze unless defined?(PREDICATE_INTERFACE_METHODS)

  match do |subject|
    PREDICATE_INTERFACE_METHODS.all? {|method_name|
      subject.respond_to?(method_name)
    }
  end

  description do
    "implmenents the Predicate interface"
  end

  failure_message_for_should do |subject|
    "#{subject.inspect} should respond to #{PREDICATE_INTERFACE_METHODS.inspect}"
  end
end
