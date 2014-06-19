# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_data_definition_interface do

  match do |subject|
    [:identity, :identity=, :name_for_application_usage, '<=>', :name_for_application_usage=].all? { |method_name|
      begin
        subject.public_method(method_name)
      rescue NameError
        false
      end
    }
  end

  description { 'implements the DataDefinition interface' }
end
