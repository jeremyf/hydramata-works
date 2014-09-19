require 'rails/generators'

module Hydramata
  module Works
    class ComplexPredicateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_properties_files
        template("properties_edit.html.erb", "app/views/hydramata/works/properties/#{file_name}/_edit.html.erb")
        template("properties_new.html.erb", "app/views/hydramata/works/properties/#{file_name}/_new.html.erb")
      end

      def create_values_files
        template("values_show.html.erb", "app/views/hydramata/works/values/#{file_name}/_show.html.erb")
      end
    end
  end
end
