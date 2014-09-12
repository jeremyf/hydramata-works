require 'hydramata/works/conversions/presented_fieldsets'
require 'hydramata/works/conversions/work_type'
require 'hydramata/works/conversions/presenter'
require 'hydramata/works/base_presenter'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Work-like
    # object to an output buffer.
    class WorkPresenter < BasePresenter
      include Conversions

      attr_reader :presentation_structure, :presented_fieldset_builder, :actions

      def initialize(collaborators = {}, &block)
        work = collaborators.fetch(:work)
        super(work, collaborators)
        @presentation_structure = collaborators.fetch(:presentation_structure) { default_presentation_structure }
        @presented_fieldset_builder = collaborators.fetch(:presented_fieldset_builder) { default_presented_fieldset_builder }
        @actions = collaborators.fetch(:actions_container) { default_actions_container }
        yield(self) if block_given?
      end

      def fieldsets
        @fieldsets ||= presented_fieldset_builder.call(work: self, presentation_structure: presentation_structure)
      end

      def work_type
        @work_type ||= Presenter(super)
      end

      def view_path_slug_for_object
        'works'
      end

      private

      def default_dom_attributes
        {
          :class => [dom_class, presenter_dom_class],
          :itemscope => true,
          :itemtype => itemtype_schema_dot_org
        }
      end

      def presenter_dom_class
        'work'
      end

      def base_dom_class
        work_type.to_s.downcase.gsub(/[\W_]+/, '-')
      end

      def default_presented_fieldset_builder
        ->(collaborators) { PresentedFieldsets(collaborators) }
      end

      def default_partial_prefixes
        [
          [ViewPathFragment(self)]
        ]
      end

      def default_translation_scopes
        [
          ['work_types', TranslationKeyFragment(self)]
        ]
      end

      def default_actions_container
        require 'hydramata/works/action_set'
        ActionSet.new(context: self)
      end

      def default_presentation_structure
        work_type
      end

    end
  end
end
