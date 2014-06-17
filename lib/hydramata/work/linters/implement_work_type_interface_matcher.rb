# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_work_type_interface do
  WORK_TYPE_INTERFACE_METHODS = [
    :identity,
    :name_for_application_usage
  ].freeze unless defined?(WORK_TYPE_INTERFACE_METHODS)

  match do |subject|
    WORK_TYPE_INTERFACE_METHODS.all? { |method_name|
      subject.respond_to?(method_name)
    }
  end

  description { 'implemenents the WorkType interface' }
end
