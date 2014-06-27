require 'spec_fast_helper'
require 'hydramata/work/dom_attributes_builder'

module Hydramata
  module Work
    describe DomAttributesBuilder do
      let(:context) { double }

      it 'should append attributes' do
        response = described_class.call(context, { class: ['hello'] }, { class: ['world'] } )
        expect(response).to eq({ class: ['hello', 'world'] })
      end

      it 'should handle mixed array and string' do
        response = described_class.call(context, { class: 'hello' }, { class: ['world'] } )
        expect(response).to eq({ class: ['hello', 'world'] })
      end

      it 'should add new keys to returned value' do
        response = described_class.call(context, { data_attribute: ['hello'] }, { class: ['world'] } )
        expect(response).to eq({ data_attribute: ['hello'], class: ['world'] })
      end

    end
  end
end