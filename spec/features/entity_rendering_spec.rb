require 'feature_helper'

describe 'An entity and presentation structure' do
  let(:entity) do
    Hydramata::Work::Entity.new do |entity|
      entity.properties << { predicate: :title, value: 'Hello' }
      entity.properties << { predicate: :title, value: 'World' }
      entity.properties << { predicate: :title, value: 'Bang!' }
      entity.properties << { predicate: :abstract, value: 'Long Text' }
      entity.properties << { predicate: :abstract, value: 'Longer Text' }
      entity.properties << { predicate: :keyword, value: 'Programming' }
    end
  end

  let(:presentation_structure) do
    Hydramata::Work::PresentationStructure.new do |struct|
      struct.fieldset(:required) do |fieldset|
        fieldset.push predicate: :title
      end
      struct.fieldset(:optional) do |fieldset|
        fieldset.push predicate: :abstract
        fieldset.push predicate: :keyword
      end
    end
  end

  let(:renderer) do
    Hydramata::Work::Renderer.new(
      context: :show,
      content_type: :html,
      entity: entity,
      presentation_structure: presentation_structure
    )
  end

  it 'renders as a well-structured HTML document' do
    rendered_output = renderer.call

    expect(rendered_output).to have_tag('.work') do
      with_tag('.required .title .label', text: 'Title')
      with_tag('.required .title .value', text: 'Hello')
      with_tag('.required .title .value', text: 'World')
      with_tag('.required .title .value', text: 'Bang!')
      with_tag('.optional .abstract .label', text: 'Abstract')
      with_tag('.optional .abstract .value', text: 'Long Text')
      with_tag('.optional .abstract .value', text: 'Longer Text')
      with_tag('.optional .keyword .label', text: 'Keyword')
      with_tag('.optional .keyword .value', text: 'Programming')
    end
  end
end
