require 'spec_fast_helper'
require 'hydramata/works/value_presenter'
require 'hydramata/works/work'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe ValuePresenter do
      let(:work) { Work.new(work_type: 'a work type') }
      let(:predicate) { Predicate.new(identity: 'a predicate') }
      let(:value) { double('Value', to_s: 'HELLO WORLD') }
      let(:renderer) { double('Renderer', call: true) }
      let(:template) { double('Template') }
      subject { described_class.new(value: value, work: work, predicate: predicate, renderer: renderer) }

      it 'renders via the template' do
        expect(renderer).to receive(:call).with(template).and_return('YES')
        expect(subject.render(template)).to eq('YES')
      end

      it 'renders the value as a string' do
        expect(renderer).to receive(:call).with(template).and_yield
        expect(subject.render(template)).to eq(value.to_s)
      end

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['a_work_type','a_predicate'], ['a_predicate']])
      end

      it 'has a label that delegates to the underlying object' do
        expect(subject.label).to eq(value.to_s)
      end
    end
  end
end
