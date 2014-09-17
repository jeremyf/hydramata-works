require 'hydramata/works/conversions'

module Hydramata
  module Works
    # Hydramata::Works is a [Rails::Engine](http://guides.rubyonrails.org/engines.html)
    #
    # These are the pieces necessary for coordinating the Hydramata::Works with
    # your instance of a Rails application.
    class Engine < ::Rails::Engine
      engine_name 'hydramata_works'


      generators do
        require 'generators/hydramata-works/complex_predicate/complex_predicate_generator'
      end

      if config.respond_to?(:eager_load_namespaces)
        # SimpleForm did this, so I'm thinking that I will do it.
        config.eager_load_namespaces << Hydramata::Works
      end

      initializer 'hydramata_works.initializers' do |app|
        app.config.paths.add 'app/presenters', eager_load: true
        app.config.paths.add 'app/parsers', eager_load: true
        app.config.paths.add 'app/runners', eager_load: true
        app.config.paths.add 'app/services', eager_load: true
        app.config.paths.add 'app/validators', eager_load: true
        app.config.autoload_paths += %W(
          #{config.root}/app/presenters
          #{config.root}/app/parsers
          #{config.root}/app/runners
          #{config.root}/app/services
          #{config.root}/app/validators
        )
      end

      initializer 'hydramata_works.services' do |app|
        ActiveSupport.on_load(:hydramata_services) do
          require 'hydramata/works/service_methods'
          include ServiceMethods
        end
      end

      initializer 'hydramata_works.configuration' do |app|
        ActiveSupport.on_load(:hydramata_configuration) do
          require 'hydramata/works/configuration_methods'
          include ConfigurationMethods
        end
      end
    end
  end
end
