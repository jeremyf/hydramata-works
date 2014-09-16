require 'spec_fast_helper'
require 'hydramata/works/property_presenter'
require 'hydramata/works/work'
require 'hydramata/works/conversions/property'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe PropertyPresenter do
      include Conversions
      let(:work) { Work.new(work_type: 'a work type') }
      let(:predicate) { Predicate.new(identity: 'my_predicate', validations: { required: true } ) }
      let(:property) { Property(predicate: predicate) }
      let(:renderer) { double('Renderer', call: true) }
      subject { described_class.new(property: property, work: work, renderer: renderer) }

      it 'delegates render to the renderer' do
        template = double
        expect(renderer).to receive(:call).with(template: template).and_return('YES')
        expect(subject.render(template: template)).to eq('YES')
      end

      it 'has a default partial prefixes' do
        expect(subject.partial_prefixes).to eq([['a_work_type','my_predicate'], ['my_predicate']])
      end

    end
  end
end
