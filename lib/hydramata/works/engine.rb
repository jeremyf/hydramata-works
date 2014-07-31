module Hydramata
  module Works
    # Hydramata::Works is a [Rails::Engine](http://guides.rubyonrails.org/engines.html)
    #
    # These are the pieces necessary for coordinating the Hydramata::Works with
    # your instance of a Rails application.
    class Engine < ::Rails::Engine
      engine_name 'hydramata_works'

      if config.respond_to?(:eager_load_namespaces)
        # SimpleForm did this, so I'm thinking that I will do it.
        config.eager_load_namespaces << Hydramata::Works
      end

      initializer 'hydramata_works.initializers' do |app|
        app.config.paths.add 'app/renderers', eager_load: true
        app.config.paths.add 'app/forms', eager_load: true
        app.config.paths.add 'app/persisters', eager_load: true
        app.config.paths.add 'app/presenters', eager_load: true
        app.config.paths.add 'app/parsers', eager_load: true
        app.config.autoload_paths += %W(
          #{config.root}/app/renderers
          #{config.root}/app/forms
          #{config.root}/app/persisters
          #{config.root}/app/presenters
          #{config.root}/app/parsers
        )
      end
    end
  end
end
