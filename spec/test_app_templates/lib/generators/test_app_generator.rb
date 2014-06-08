require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  # def install_engine
  #   generate 'hydramata-work:install'
  # end

  def run_migrations
    rake 'db:create'
    rake 'hydramata_work:install:migrations'
    rake 'db:migrate'
    rake 'db:test:prepare'
  end

end
