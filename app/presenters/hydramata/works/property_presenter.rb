require 'hydramata/works/base_presenter'
require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    # Responsible for coordinating the rendering of an in-memory Property-like
    # object to an output buffer.
    class PropertyPresenter < BasePresenter
      attr_reader :work, :value_presenter_builder
      private :value_presenter_builder
      def initialize(collaborators = {})
        property = collaborators.fetch(:property)
        @work = collaborators.fetch(:work)
        super(property, collaborators)
        @value_presenter_builder = collaborators.fetch(:value_presenter_builder) { default_value_presenter_builder }
      end

      def values
        @values ||= __getobj__.values.collect {|value| value_presenter_builder.call(value: value, predicate: self, work: work) }
      end

      def view_path_slug_for_object
        'properties'
      end

      def dom_label_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { id: dom_id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'label' << presenter_dom_class << dom_class
        returning[:class] << 'required' if predicate.required?
        returning
      end

      def dom_value_attributes(options = {})
        returning = { 'aria-labelledby' => dom_id_for_label }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'value' << presenter_dom_class << dom_class
        returning
      end

      def dom_input_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { 'aria-labelledby' => dom_id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'value' << presenter_dom_class << dom_class
        returning['required'] = 'required' if predicate.required?
        returning[:name] ||= dom_name_for_field(suffix: suffix)
        returning
      end

      def dom_id_for_field(index: 0, suffix: nil, prefix: nil)
        parts = []
        parts << prefix if prefix
        parts << "work_#{predicate}"
        parts << suffix if suffix
        parts << "#{index}" if index
        parts.join("_")
      end

      def dom_id_for_label(prefix: nil, index: nil, suffix: nil)
        parts = ["label_for"]
        parts << prefix if prefix
        parts << "work_#{predicate}"
        parts << suffix if suffix
        parts << "#{index}" if index
        parts.join("_")
      end

      def dom_name_for_field(suffix: nil)
        returning_value = "work[#{predicate}]"
        returning_value << "[#{suffix}]" if suffix
        returning_value << "[]"
        returning_value
      end

      private

      def default_dom_attributes
        { class: [dom_class, presenter_dom_class] }
      end

      def default_presentation_context
        work.respond_to?(:presentation_context) ? work.presentation_context : 'show'
      end

      def default_partial_prefixes
        work_prefix = ViewPathFragment(work)
        predicate_prefix = ViewPathFragment(predicate)
        [
          [work_prefix, predicate_prefix],
          [predicate_prefix]
        ]
      end

      def default_translation_scopes
        work_prefix = TranslationKeyFragment(work)
        predicate_prefix = TranslationKeyFragment(predicate)
        [
          ['work_types', work_prefix, view_path_slug_for_object, predicate_prefix],
          [view_path_slug_for_object, predicate_prefix]
        ]
      end

      def default_value_presenter_builder
        require 'hydramata/works/value_presenter_finder'
        ->(options) { ValuePresenterFinder.call(predicate).new(options) }
      end
    end
  end
end
