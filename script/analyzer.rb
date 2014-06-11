#!/usr/local/bin/ruby

require 'pp'
require 'sexp_processor'
require 'ruby_parser'
require 'byebug'
require 'rake'

class DependencyAnalyzer < MethodBasedSexpProcessor

  class Collaborators
    def initialize
      @storage = {}
    end
    def push(class_stack, collaborators)
      klass = class_stack.reverse[0..-1].collect(&:to_s).join('::')
      @storage[klass] ||= []
      @storage[klass] << collaborators
    end
  end

  attr_reader :collaborators

  def initialize
    super
    @collaborators = Collaborators.new
  end

  def process_const(exp)
    exp.shift
    collaborator = exp.shift
    collaborators.push(class_stack, collaborator)
    return s(:const, collaborator)
  end

end

if __FILE__ == $0
  
  # parsed_object = s(:module, :Hydramata, s(:module, :Work, s(:class, :Entity, nil, s(:defn, :initialize, s(:args, s(:lasgn, :collaborators, s(:hash)), :"&block"), s(:iasgn, :@properties, s(:iter, s(:call, s(:lvar, :collaborators), :fetch, s(:lit, :properties_container)), s(:args), s(:call, nil, :default_properties_container))), s(:if, s(:call, nil, :block_given?), s(:call, s(:lvar, :block), :call, s(:self)), nil)), s(:call, nil, :attr_accessor, s(:lit, :work_type)), s(:call, nil, :attr_reader, s(:lit, :properties)), s(:call, nil, :private), s(:defn, :default_properties_container, s(:args), s(:call, nil, :require, s(:str, "hydramata/work/property_set")), s(:call, s(:const, :PropertySet), :new, s(:hash, s(:lit, :entity), s(:self)))))))
  file = File.read('/Users/jfriesen/Repositories/hydramata-work/app/models/hydramata/work/entity.rb')
  parsed_object = RubyParser.for_current_ruby.parse(file)
  dep_analyzer = DependencyAnalyzer.new
  dep_analyzer.process(parsed_object)
  puts dep_analyzer.collaborators
end
