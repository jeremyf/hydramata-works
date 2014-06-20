module Hydramata
  module Work
    module Linters
      module InterfaceMatcherBuilder
        module_function
        def call(context, input_klass_name, input_method_names)
          context.instance_exec(input_klass_name, input_method_names) do |klass_name, method_names|

            match do |subject|
              method_names.all? { |method_name| subject.respond_to?(method_name) } &&
                method_expectations.all? { |method_name, value| subject.public_send(method_name) == value }
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
