require 'fast_helper'
require 'hydramata/work/base_presenter'

module Hydramata
  module Work
    class MockPresentable
      attr_accessor :name
      def initialize
        yield(self) if block_given?
      end
    end
    describe BasePresenter do
      let(:name) { 'hello world' }
      let(:object) { MockPresentable.new { |b| b.name = name } }
      let(:translator) { double('Translator', t: true) }
      subject { described_class.new(object, translator: translator) }

      it 'should have a friendly inspect message, because tracking it down could be a pain' do
        expect(subject.inspect).to include("#{described_class}:#{subject.object_id}")
        expect(subject.inspect).to include(object.inspect)
      end

      it 'should be an instance of the presented object\'s class' do
        expect(subject.instance_of?(object.class)).to be_truthy
      end

      it 'should also be an instance of the presenter class' do
        expect(subject.instance_of?(described_class)).to be_truthy
      end

      it 'should translate attribute keys' do
        subject.translate(:name)
        expect(translator).to have_received(:t).with('hydramata.work.base.name', default: instance_of(Proc))
      end

      it 'has a #dom_class' do
        expect(subject.dom_class).to eq('hello-world')
      end

    end
  end
end
