require 'spec_fast_helper'
require 'hydramata/work/conversions/presenter'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#Presenter' do
        it 'converts an object that implements #to_presenter' do
          object = double(to_presenter: :presenter)
          expect(Presenter(object)).to eq(:presenter)
        end

        it 'does not convert an object that does not implement a #to_presenter' do
          object = double
          expect(Presenter(object)).to eq(object)
        end
      end
    end
  end
end
