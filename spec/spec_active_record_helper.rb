# This helper provides at least a x2 speed increase over the 'spec_slow_helper'.
#
# To validate this assumption, find a spec for an ActiveRecord object, and run
# with `rspec -r spec/spec_active_record_helper.rb ./path/to/spec.rb`
#
# Example:
# $ time rspec -r spec/spec_active_record_helper.rb spec/features/new_user_input_to_in_memory_spec.rb
#
#     real  0m1.576s
#     user  0m1.093s
#     sys   0m0.295s
#
# Compared to `rspec -r spec/spec_slow_helper.rb ./path/to/spec.rb`
#
# Example:
# $ time rspec -r spec/spec_slow_helper.rb spec/features/new_user_input_to_in_memory_spec.rb
#
#     real  0m3.546s
#     user  0m2.417s
#     sys   0m0.702s
require 'active_record'
require 'spec_fast_helper'

if !defined?(Rails)
  # Sometimes this will be invoked when Rails is defined. In that case the relative
  # path is ../internal. When Rails is not defined the relative path is different.
  # By providing an absolute path, I avoid either of those silly things.
  database = File.expand_path('../internal/db/development.sqlite3', __FILE__)

  connection_info = { adapter: 'sqlite3', database: database, pool: 5, timeout: 5000 }
  ActiveRecord::Base.establish_connection(connection_info)
end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      fail ActiveRecord::Rollback
    end
  end
end
