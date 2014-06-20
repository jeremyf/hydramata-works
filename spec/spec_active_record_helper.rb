# This helper provides a x2 speed increase over the 'spec_slow_helper'
#
# To validate this assumption, find a spec for an ActiveRecord object
# (eg spec/hydramata/works/predicate_spec.rb)
# $ time rspec spec/hydramata/works/predicate_spec.rb
#
# Then change the "require 'spec_active_record_helper'" to "require 'spec_slow_helper'"
# $ time rspec spec/hydramata/works/predicate_spec.rb

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
