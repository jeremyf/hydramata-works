module Hydramata
  module Work
    # Hydramata::Work is a [Rails::Engine](http://guides.rubyonrails.org/engines.html)
    #
    # These are the pieces necessary for coordinating the Hydramata::Work with
    # your instance of a Rails application.
    class Engine < ::Rails::Engine
      engine_name 'hydramata_work'

      initializer 'hydramata_work.initializers' do |app|
        app.config.paths.add 'app/renderers', eager_load: true
        app.config.paths.add 'app/presenters', eager_load: true
        app.config.paths.add 'app/parsers', eager_load: true
        app.config.paths.add 'app/wranglers', eager_load: true
        app.config.autoload_paths += %W(
          #{config.root}/app/renderers
          #{config.root}/app/presenters
          #{config.root}/app/parsers
          #{config.root}/app/wranglers
        )
      end
    end
  end
end
