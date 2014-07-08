#!/usr/local/bin/ruby

require 'pp'
require 'sexp_processor'
require 'ruby_parser'
require 'byebug'
require 'rake'
require 'set'

class Collector
  attr_reader :namespace
  def initialize(namespace)
    @namespace = namespace
    @storage = {}
  end

  def push(class_stack, collaborator)
    klass = register(class_stack)
    @storage[klass] << collaborator
  end

  def register(class_stack)
    klass = class_stack.reverse[0..-1].collect(&:to_s).join('::')
    @storage[klass] ||= Set.new
    klass
  end

  def render
    puts %(digraph "G" {)
    puts %(    label="#{namespace}") if namespace
    @storage.each do |klass, collaborators|
      if klass.strip != '' || collaborators.any? {|c| c =~ /\A#{namespace}/ }
        puts render_node(klass)
        collaborators.each do |collaborator|
          if @storage.detect do |some_class, _|
              if some_class =~ /\A#{namespace}(::\w+)*::#{collaborator}\Z/
                render_node(some_class)
                render_edge(klass, some_class)
                true
              else
                false
              end
            end
          else
            if collaborator =~ /\A#{namespace}/
              render_node(collaborator)
              render_edge(klass, collaborator)
            end
          end
        end
      end
    end
    puts %(})
  end

  def render_node(klass)
    puts %(    #{to_dot_name(klass)}[label="#{klass}"])
  end

  def render_edge(from, to)
    puts %(    #{to_dot_name(from)} -> #{to_dot_name(to)})
  end

  def to_dot_name(str)
    str.gsub(/[\W:]+/,'_')
  end
end

class DependencyAnalyzer < MethodBasedSexpProcessor

  attr_reader :collector

  def initialize(collector = Collector.new)
    super()
    @collector = collector
  end

  def process_colon2(exp)
    klass = classify_colon2(exp).join("::")
    collector.push(class_stack, klass)
    return exp
  end

  def process_module(exp)
    super(exp)
    collector.register(class_stack)
    return exp
  end

  def process_dfn(exp)
    collector.register(class_stack)
    return exp
  end

  def process_const(exp)
    collaborator = exp[1]
    collector.push(class_stack, collaborator.to_s)
    return s(:const, collaborator)
  end

  def classify_colon2(exp, returning = [])
    returning.unshift(exp[2]) if exp[2]
    if exp[1].is_a?(Sexp)
      classify_colon2(exp[1], returning)
    else
      returning.unshift(exp[1])
    end
    return returning
  end

end

if __FILE__ == $0
  collaborator = Collector.new('Hydramata::Works')
  analyzer = DependencyAnalyzer.new(collaborator)
  FileList['app/**/*.rb', 'lib/**/*.rb'].each do |filename|
  # filename = '/Users/jfriesen/Repositories/hydramata-work/app/parsers/hydramata/works/predicate_parsers/simple_parser.rb'
    file_content = File.read(filename)
    parsed_file = RubyParser.for_current_ruby.parse(file_content)
    # break
    analyzer.process(parsed_file)
  end
  collaborator.render
end
