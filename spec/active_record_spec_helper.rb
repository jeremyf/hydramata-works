require 'active_record'
require 'fast_helper'

connection_info = YAML.load_file(File.expand_path('../internal/config/database.yml', __FILE__))['test']
ActiveRecord::Base.establish_connection(connection_info)

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      fail ActiveRecord::Rollback
    end
  end
end
