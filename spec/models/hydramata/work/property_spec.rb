require 'fast_helper'
require 'hydramata/work/property'

module Hydramata
  module Work
    describe Property do
      let(:predicate) { double('Predicate') }
      let(:value) { double('Value') }
      subject { described_class.new(predicate: predicate) }

      it { should respond_to :values }

      it 'can append to values' do
        expect { subject << value }
        .to change { subject.values }
        .from([])
        .to([value])
      end
    end
  end
end
