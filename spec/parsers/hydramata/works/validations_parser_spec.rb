require 'spec_fast_helper'
require 'hydramata/works/validations_parser'

module Hydramata
  module Works
    describe ValidationsParser do
      context '.call' do
        it 'parses simple JSON' do
          expect(described_class.call('{"presence": true}')).to eq({ 'presence' => true })
        end

        it 'returns an empty hash when input is nil' do
          expect(described_class.call(nil)).to eq({})
        end

        it 'returns an empty hash when input is an empty string' do
          expect(described_class.call('')).to eq({})
        end

        it 'returns the same Hash if one is given' do
          object = {a: 1}
          expect(described_class.call(object).object_id).to eq(object.object_id)
        end

        it 'raises an error on unexpected input' do
          expect{ described_class.call(Object.new) }.to raise_error
        end
      end
    end
  end
end
