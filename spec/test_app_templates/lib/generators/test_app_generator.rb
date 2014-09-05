require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application


  def run_migrations
    rake 'db:create'
    rake 'hydramata_works:install:migrations'
    rake 'db:migrate'
  end

end
