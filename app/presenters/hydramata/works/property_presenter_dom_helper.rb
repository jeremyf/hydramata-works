require 'delegate'

module Hydramata
  module Works
    class PropertyPresenterDomHelper < SimpleDelegator
      def initialize(property)
        __setobj__(property)
      end

      def label_attributes(options ={})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { id: id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'label' << presenter_dom_class << dom_class
        returning[:class] << 'required' if predicate.required?
        returning
      end

      def value_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { 'aria-labelledby' => id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'value' << presenter_dom_class << dom_class
        returning
      end

      def input_attributes(options = {})
        options = options.clone
        suffix = options.delete(:suffix)
        index = options.delete(:index)
        returning = { 'aria-labelledby' => id_for_label(suffix: suffix, index: index) }.deep_merge(options)
        returning[:class] = Array.wrap(returning[:class])
        returning[:class] << 'value' << presenter_dom_class << dom_class
        returning['required'] = 'required' if predicate.required?
        returning[:name] ||= name_for_field(suffix: suffix)
        returning
      end

      def id_for_field(index: 0, suffix: nil, prefix: nil)
        parts = []
        parts << prefix if prefix
        parts << "work_#{predicate}"
        parts << suffix if suffix
        parts << "#{index}" if index
        parts.join("_")
      end

      def id_for_label(prefix: nil, index: nil, suffix: nil)
        parts = ["label_for"]
        parts << prefix if prefix
        parts << "work_#{predicate}"
        parts << suffix if suffix
        parts << "#{index}" if index
        parts.join("_")
      end

      def name_for_field(suffix: nil)
        returning_value = "work[#{predicate}]"
        returning_value << "[#{suffix}]" if suffix
        returning_value << "[]"
        returning_value
      end
    end
  end
end
