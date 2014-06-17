# RSpec matcher to spec delegations.
require 'rspec/matchers'

RSpec::Matchers.define :implement_data_definition_interface do

  match do |subject|
    [:identity, :identity=].all? { |method_name|
      subject.respond_to?(method_name)
    }
  end

  description { 'implements the DataDefinition interface' }
end
