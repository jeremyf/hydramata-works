require 'hydramata/works/work'
require 'hydramata/works/apply_user_input_to_work'
require 'hydramata/works/work_presenter'
require 'hydramata/works/work_form'
require 'hydramata/works/work_types/storage'
require 'hydramata/works/works/database_storage'
require 'hydramata/works/to_persistence'

module Hydramata
  module Works
    # Responsible for being a collection of service methods that are useful
    # for negotiating between a context (i.e. a Controller request ) and the
    # domain model.
    #
    # This module defines the public API for interacting with Hydramata::Works.
    #
    # As Hydramata::Works is in a pre-release state, this code is subject to
    # change.
    #
    # @todo finalize external API with v1.0.0 release
    # @see semver.org
    module ServiceMethods
      # @param :work_type [String]
      # @param :attributes [Hash]
      # @yield [work]
      # @yieldparam work [WorkForm]
      # @return [WorkForm]
      def new_work_for(work_type, attributes = {}, &block)
        work = Work.new(work_type: work_type)
        ApplyUserInputToWork.call(work: work, attributes: attributes) if attributes.present?
        presenter = WorkPresenter.new(work: work, presentation_context: :new)
        presenter.actions << { name: :create }
        WorkForm.new(presenter, &block)
      end

      # @return [Array(WorkType)]
      def available_work_types
        WorkTypes::Storage.ordered.all.collect do |work_type|
          work_type.to_work_type(shallow: true).to_presenter
        end
      end

      # @param :work [#save]
      # @return [Boolean]
      def save_work(work)
        state = work.valid? ? 'valid' : 'invalid'
        ToPersistence.call(work: work, state: state) && state
      end

      # @param identity [#to_s]
      # @yield [presenter]
      # @yieldparam presenter [WorkPresenter]
      # @return [WorkPresenter]
      def find_work(identity)
        work_finder(identity, presentation_context: :show) do |work|
          work.actions << { name: :edit }
        end
      end

      # @param identity [#to_s]
      # @param options [Hash]
      # @return [WorkForm]
      def edit_work(identity, attributes = {}, &block)
        presented_work = work_finder(identity, presentation_context: :edit) do |work|
          work.actions << { name: :update }
        end
        if attributes.present?
          ApplyUserInputToWork.call(
            work: presented_work,
            attributes: attributes,
            property_value_strategy: :replace_values
          )
        end
        WorkForm.new(presented_work, &block)
      end

      private

      def work_finder(identity, options = {})
        # @TODO - Given that we are going to have data across multiple sources
        # should there be a chain of lookups? (eg { sequence: :database })
        work = Works::DatabaseStorage.where(pid: identity).first.to_work
        WorkPresenter.new(options.merge(work: work)) do |presenter|
          yield(presenter) if block_given?
        end
      end
    end
  end
end
