require 'hydramata/core/runner'

module Hydramata
  module Works
    module WorkRunners

      class AvailableType < Hydramata::Core::Runner
        def run
          work_types = services.available_work_types
          callback(:success, work_types)
        end
      end

      class New < Hydramata::Core::Runner
        def run(work_type, attributes)
          work = services.new_work_for(work_type, attributes)
          callback(:success, work)
        end
      end

      class Create < Hydramata::Core::Runner
        def run(work_type, attributes)
          work = services.new_work_for(work_type, attributes)
          case services.save_work(work)
          when 'valid' then callback(:success, work)
          when 'invalid' then callback(:created_with_invalid_data, work)
          else
            callback(:failure, work)
          end
        end
      end

      class Show < Hydramata::Core::Runner
        def run(identifier)
          work = services.find_work(identifier)
          callback(:success, work)
        end
      end

      class Edit < Hydramata::Core::Runner
        def run(identifier, attributes = {})
          work = services.edit_work(identifier, attributes)
          callback(:success, work)
        end
      end

      class Update < Hydramata::Core::Runner
        def run(work_type, attributes)
          work = services.edit_work(work_type, attributes)
          case services.save_work(work)
          when 'valid' then callback(:success, work)
          when 'invalid' then callback(:updated_with_invalid_data, work)
          else
            callback(:failure, work)
          end
        end
      end

    end
  end
end
