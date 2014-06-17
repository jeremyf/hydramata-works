require 'feature_helper'

# This spec verifies that the Entity -> Fieldset -> Properties render chain
# uses the same presentation context for the entire render process.
module Hydramata
  module Work
    describe 'An entity and presentation structure' do
      context 'with view_path override and format' do
        it 'uses the found views instead of the defaults' do
          rendered_output = renderer.render
          expect(rendered_output.strip).to eq("ENTITY article\nFIELDSET required\nPROPERTY title")
        end

        around do |example|
          begin
            generate_template(
              'works',
              "ENTITY <%= #{presentation_context}.t(:work_type)%>",
              "<% #{presentation_context}.fieldsets.each do |f|%><%= f.render(template: self) %><% end %>"
            )
            generate_template(
              'fieldsets',
              "FIELDSET <%= #{presentation_context}.t(:name)%>",
              "<% #{presentation_context}.each do |f|%><%= f.render(template: self) %><% end %>"
            )
            generate_template('properties', "PROPERTY <%= #{presentation_context}.t(:name) %>")
            example.run
          ensure
            cleanup_template('works')
            cleanup_template('fieldsets')
            cleanup_template('properties')
          end
        end

      end

      def generate_template(name, *lines)
        path = File.expand_path("../../../#{view_path}/hydramata/work/#{name}/_#{presentation_context}.#{format}.erb", __FILE__)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.puts lines.join("\n") }
      end

      def cleanup_template(name)
        path = File.expand_path("../../../#{view_path}/hydramata/work/#{name}/_#{presentation_context}.#{format}.erb", __FILE__)
        File.unlink(path) if File.exist?(path)
      end

      let(:entity) do
        Entity.new.tap do |entity|
          entity.work_type = 'article'
          entity.properties << { predicate: :title, value: 'Hello' }
        end
      end

      let(:presentation_structure) do
        PresentationStructure.new.tap do |struct|
          struct.fieldsets << [:required, [:title]]
        end
      end

      let(:presentation_context) { :nonsense }
      let(:view_path) { 'app/views/articles' }
      let(:format) { :elvis }

      let(:entity_presenter) do
        EntityPresenter.new(entity: entity, presentation_structure: presentation_structure, presentation_context: presentation_context)
      end

      let(:renderer) { EntityRenderer.new(entity: entity_presenter, format: format, view_path: view_path) }
    end
  end
end
