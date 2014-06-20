module Hydramata
  module Work
    module Linters
      module InterfaceMatcherBuilder
        module_function
        def call(context, input_klass_name, input_method_names)
          context.instance_exec(input_klass_name, input_method_names) do |klass_name, method_names|
            match do |subject|
              returning_value = method_names.all? do |(method_name, second_level_methods)|
                subject.respond_to?(method_name) &&
                Array(second_level_methods).all? do |second_level_method|
                  subject.public_send(method_name).respond_to?(second_level_method)
                end
              end && method_expectations.all? do |method_name, value|
                subject.public_send(method_name) == value
              end
              returning_value
            end

            chain :with do |method_name, value|
              method_expectations[method_name] = value
            end

            description { "implemenents the #{input_klass_name} interface" }
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
