require 'spec_fast_helper'
require 'hydramata/works/configuration_methods'

module Hydramata
  module Works
    describe ConfigurationMethods do
      Given(:configuration) do
        Class.new do
          include ConfigurationMethods
        end.new
      end
      context 'default #work_model_name' do
        When(:work_model_name) { configuration.work_model_name }
        Then { work_model_name == 'Work' }
      end
      context 'override #work_model_name' do
        Given(:work_model_name) { 'SomethingDifferent' }
        When { configuration.work_model_name = work_model_name }
        Then { configuration.work_model_name == work_model_name }
      end
    end
  end
end
