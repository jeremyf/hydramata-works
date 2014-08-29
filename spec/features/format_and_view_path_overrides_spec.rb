require 'spec_slow_helper'

# This spec verifies that the Work -> Fieldset -> Properties render chain
# uses the same presentation context for the entire render process.
module Hydramata
  module Works
    describe 'A work and presentation structure' do
      context 'with view_path override and format' do
        let(:work) do
          Work.new(work_type: 'article') do |work|
            work.properties << { predicate: :title, value: 'Hello' }
          end
        end

        let(:presentation_structure) do
          PresentationStructure.new do |struct|
            struct.fieldsets << [:required, [:title]]
          end
        end

        it 'uses the found views instead of the defaults' do
          rendered_output = renderer.render
          expect(rendered_output.strip).to eq("ENTITY article\nFIELDSET required\nPROPERTY title")
        end

        around do |example|
          begin
            generate_template(
              'works',
              "ENTITY <%= #{presentation_context}.work_type %>",
              "<% #{presentation_context}.fieldsets.each do |f|%><%= f.render(template: self) %><% end %>"
            )
            generate_template(
              'fieldsets',
              "FIELDSET <%= #{presentation_context}.label%>",
              "<% #{presentation_context}.each do |f|%><%= f.render(template: self) %><% end %>"
            )
            generate_template('properties', "PROPERTY <%= #{presentation_context}.label %>")
            example.run
          ensure
            cleanup_template('works')
            cleanup_template('fieldsets')
            cleanup_template('properties')
          end
        end

      end

      def generate_template(name, *lines)
        path = File.expand_path("../../../#{view_path}/hydramata/works/#{name}/_#{presentation_context}.#{format}.erb", __FILE__)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.puts lines.join("\n") }
      end

      def cleanup_template(name)
        path = File.expand_path("../../../#{view_path}/hydramata/works/#{name}/_#{presentation_context}.#{format}.erb", __FILE__)
        File.unlink(path) if File.exist?(path)
      end

      let(:presentation_context) { :nonsense }
      let(:view_path) { 'app/views/articles' }
      let(:format) { :elvis }

      let(:work_presenter) do
        WorkPresenter.new(work: work, presentation_structure: presentation_structure, presentation_context: presentation_context)
      end

      let(:renderer) { WorkRenderer.new(work: work_presenter, format: format, view_path: view_path) }
    end
  end
end
