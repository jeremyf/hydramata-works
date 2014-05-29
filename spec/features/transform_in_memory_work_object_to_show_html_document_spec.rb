require 'feature_helper'

describe 'Transform in memory Work object to Show HTML Document' do
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

  it 'renders respectable output' do
    rendered_output = Hydramata::Work.render(
      context: :show,
      content_type: :html,
      entity: entity,
      presentation_structure: presentation_structure
    )

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
