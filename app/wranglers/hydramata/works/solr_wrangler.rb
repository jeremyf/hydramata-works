require 'active_support/core_ext/array/wrap'

module Hydramata
  module Works
    # Responsible for wrangling up data from Solr and passing that data to
    # visiting :work.
    class SolrWrangler

      def initialize(collaborators = {})
        @work = collaborators.fetch(:work)
        @document = collaborators.fetch(:document)
      end

      attr_reader :work
      attr_reader :document

      def call
        assign_work_type
        assign_id
        work
      end

      private

      def assign_id
        work.identity = document.fetch('id')
      end

      def assign_work_type
        document_models.each do |model|
          # @TODO - This is similar to the FedoraWrangler behavior
          if model =~ /\Ainfo:fedora\/afmodel\:(.*)\Z/
            work.work_type = Regexp.last_match[1]
            break
          end
        end
      end

      def document_models
        Array.wrap(document.fetch('has_model_ssim')).reverse
      end
    end
  end
end
