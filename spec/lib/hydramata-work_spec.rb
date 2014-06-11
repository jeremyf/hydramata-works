require 'fast_helper'
require 'hydramata-work'

module Hydramata
  describe Work do
    it 'has a .table_name_prefix to conform to Rails::Engine' do
      expect(described_class.table_name_prefix).to eq('hydramata_work_')
    end

    it 'has a .use_relative_model_naming? to conform to Rails::Engine' do
      expect(described_class.use_relative_model_naming?).to eq(true)
    end
  end
end
