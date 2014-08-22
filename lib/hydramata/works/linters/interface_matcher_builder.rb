module Hydramata
  module Works
    module Linters
      module InterfaceMatcherBuilder
        module_function
        def call(context, input_klass_name, input_method_names)
          context.instance_exec(input_klass_name, input_method_names) do |klass_name, method_names|
            match do |subject|
              @missing_methods = []
              method_names.each do |(method_name, second_level_methods)|
                @missing_methods << "##{method_name}" unless subject.respond_to?(method_name)
                Array(second_level_methods).each do |second_level_method|
                  unless subject.public_send(method_name).respond_to?(second_level_method)
                    @missing_methods << "##{method_name}##{second_level_method}"
                  end
                end
              end

              method_expectations.each do |method_name, value|
                @missing_methods << "##{method_name} != #{value.inspect}" unless subject.public_send(method_name) == value
              end
              @missing_methods.size == 0
            end

            chain :with do |method_name, value|
              method_expectations[method_name] = value
            end

            description { "implemenent the #{input_klass_name} interface" }

            failure_message do |subject|
              "expected #{subject.inspect} to implement the #{input_klass_name} interface. The following methods were in error: #{@missing_methods.join(", ")}"
            end
          end

          context.module_exec do
            def method_expectations
              @method_expectations ||= {}
            end
          end
        end
      end
    end
  end
end
