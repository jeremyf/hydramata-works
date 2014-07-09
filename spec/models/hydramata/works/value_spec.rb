require 'spec_fast_helper'
require 'date'
require 'hydramata/works/value'
require 'hydramata/works/linters/implement_value_interface_matcher'

module Hydramata
  module Works
    describe Value do
      let(:raw_object) { double('Raw Object') }
      let(:value) { 123456789 }
      subject { described_class.new(value: value, raw_object: raw_object) }

      it { should implement_value_interface }

      it 'has a #raw_object' do
        expect(subject.raw_object).to eq(raw_object)
      end

      it 'has a friendly inspect message, because tracking it down could be a pain' do
        expect(subject.inspect).to include("#{described_class}")
        expect(subject.inspect).to include(raw_object.inspect)
        expect(subject.inspect).to include(value.inspect)
      end

      it 'is an instance of the presented object\'s class' do
        expect(subject.instance_of?(value.class)).to be_truthy
      end

      context '#==' do
        context 'for two value objects' do
          it 'is not true if underlying objects do not match' do
            expect(described_class.new(value: 123) == described_class.new(value: 1234)).to be_falsey
          end
          it 'is true if underlying objects match' do
            expect(described_class.new(value: Date.new(2013,1,3)) == described_class.new(value: Date.new(2013,1,3))).to be_truthy
          end
        end
        context 'for integers' do
          let(:value) { 123456789 }
          it 'is equal when base value is the same' do
            expect(subject == value).to be_truthy
          end
        end

        context 'for strings' do
          let(:value) { 'Hello World' }
          it 'is equal when base value is the same' do
            expect(subject == value).to be_truthy
          end
        end

        context 'for dates' do
          let(:value) { Date.new(2013,1,3) }
          it 'is equal when base value is the same' do
            expect(subject == Date.new(2013,1,3)).to be_truthy
          end
        end
      end
    end
  end
end
