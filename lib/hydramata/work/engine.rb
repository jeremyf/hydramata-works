module Hydramata
  module Work
    class Engine < ::Rails::Engine
      engine_name 'hydramata_work'

      initializer 'hydramata_work.initializers' do |app|
        app.config.paths.add 'app/renderers', eager_load: true
        app.config.paths.add 'app/presenters', eager_load: true
        app.config.paths.add 'app/parsers', eager_load: true
        app.config.autoload_paths += %W(
          #{config.root}/app/renderers
          #{config.root}/app/presenters
          #{config.root}/app/parsers
        )
      end

    end
  end
end
