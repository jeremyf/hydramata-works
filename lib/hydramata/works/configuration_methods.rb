module Hydramata
  module Works
    module ConfigurationMethods
      def work_model_name
        @work_model_name ||= 'Work'
      end

      def work_model_name=(string)
        @work_model_name = string
      end
    end
  end
end
