require 'spec_fast_helper'
require 'hydramata/works/property_presenter'
require 'hydramata/works/work'

module Hydramata
  module Works
    describe PropertyPresenter do
      let(:work) { Work.new(work_type: 'a work type') }
      let(:property) { double('Property', predicate: 'my_property') }
      let(:renderer) { double('Renderer', call: true) }
      subject { described_class.new(property: property, work: work, renderer: renderer) }

      it 'delegates render to the renderer' do
        template = double
        expect(renderer).to receive(:call).with(template: template).and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['a_work_type','my_property'], ['my_property']])
      end

    end
  end
end
