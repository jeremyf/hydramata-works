require 'rspec/matchers'

RSpec::Matchers.define :implement_datastream_parser_interface do
  match do |subject|
    subject.respond_to?(:match?) &&
    subject.respond_to?(:call) &&
    subject.method(:call).parameters.first[0] == :req &&
    subject.method(:call).parameters.last[1] == :block
  end

  description { "implemenent the DatastreamParser interface:\n\t#match?\n\t#call (required first parameter, takes a block)" }
end
