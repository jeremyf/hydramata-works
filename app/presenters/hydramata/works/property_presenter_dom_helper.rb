require 'delegate'
require 'active_support/core_ext/array/wrap'
require 'hydramata/works/conversions/predicate'

module Hydramata
  module Works
    class PropertyPresenterDomHelper < SimpleDelegator
      include Conversions
      attr_reader :predicate
      def initialize(property)
        @predicate = Predicate(property)
        __setobj__(property)
      end

      def container_attributes(options = {})
        # @TODO
      end

      def label_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { id: id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << presenter_dom_class(suffix: 'label') << dom_class
        returning[:class] << 'required' if predicate.required?
        returning
      end

      def value_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { 'aria-labelledby' => id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << presenter_dom_class(suffix: 'value') << dom_class
        returning
      end

      def input_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { 'aria-labelledby' => id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << presenter_dom_class(suffix: 'input') << dom_class
        with_required_attribute(suffix: suffix) do
          returning[:required] = 'required'
        end
        returning[:name] ||= name_for_field(suffix: suffix)
        returning
      end

      def id_for_field(index: 0, suffix: nil, prefix: nil)
        assemble_id(nil, index: index, suffix: suffix, prefix: prefix)
      end

      def id_for_label(prefix: nil, index: nil, suffix: nil)
        assemble_id('label_for', index: index, suffix: suffix, prefix: prefix)
      end

      def name_for_field(suffix: nil)
        returning_value = "work[#{predicate}]"
        returning_value << "[#{suffix}]" if suffix
        returning_value << "[]"
        returning_value
      end

      private

      def with_required_attribute(suffix: nil)
        @rendered ||= false
        return if @rendered
        yield if predicate.required?
      ensure
        @rendered = true
      end

      def assemble_id(leader, prefix: nil, index: nil, suffix: nil)
        parts = Array.wrap(leader)
        parts << prefix if prefix
        parts << "work_#{predicate}"
        parts << suffix if suffix
        parts << "#{index}" if index
        parts.join("_")
      end

      def presenter_dom_class(prefix: nil, suffix: nil)
        [prefix, 'property', suffix].compact.join('-')
      end
    end
  end
end
