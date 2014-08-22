require 'spec_fast_helper'
require 'hydramata/works/base_presenter'

module Hydramata
  module Works
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

      it 'has #presenter_dom_class' do
        expect(subject.presenter_dom_class).to eq('base')
      end

      it 'returns self for #to_presenter' do
        expect(subject.to_presenter.object_id).to eq(subject.object_id)
      end

      it 'has a friendly inspect message, because tracking it down could be a pain' do
        expect(subject.inspect).to include("#{described_class}")
        expect(subject.inspect).to include(object.inspect)
      end

      it 'is an instance of the presented object\'s class' do
        expect(subject.instance_of?(object.class)).to be_truthy
      end

      it 'generates container_content_tag_attributes' do
        builder = double(call: true)
        subject = described_class.new(object, translator: translator, dom_attributes_builder: builder)
        subject.container_content_tag_attributes(hello: :world)
        expect(builder).to have_received(:call).with(subject, { hello: :world }, {})
      end

      it 'is also an instance of the presenter class' do
        expect(subject.instance_of?(described_class)).to be_truthy
      end

      context '#translate' do
        it 'translates attribute keys' do
          subject.translate(:name)
          expect(translator).to have_received(:t).with(:name, scopes: [], default: instance_of(Proc))
        end

        it 'passes along options' do
          subject.translate(:name, raise: true)
          expect(translator).to have_received(:t).with(:name, scopes: [], default: instance_of(Proc), raise: true)
        end

        it 'allows defaults to be overridden' do
          subject.translate(:name, raise: true, default: nil)
          expect(translator).to have_received(:t).with(:name, scopes: [], default: nil, raise: true)
        end
      end

      context '#dom_class' do
        it 'extrapolates based on the named object' do
          expect(subject.dom_class).to eq('hello-world')
        end

        it 'allows a prefix' do
          expect(subject.dom_class(prefix: 'edit')).to eq('edit-hello-world')
        end

        it 'allows a suffix' do
          expect(subject.dom_class(suffix: '1')).to eq('hello-world-1')
        end

        it 'allows a prefix and a suffix' do
          expect(subject.dom_class(prefix: 'edit', suffix: '1')).to eq('edit-hello-world-1')
        end
      end

      context '#render' do
        let(:template) { double('Template', render: true)}

        it 'delegates render to the template' do
          subject.render(template: template)
          expect(template).to have_received(:render).with(partial: 'hydramata/works/base/show', object: subject)
        end

        it 'handles a partial_prefixes rendering in less and less specificity' do
          subject = described_class.new(object, translator: translator, partial_prefixes: ['article/required', 'article'], presentation_context: 'show', template_missing_exception: [RuntimeError, NoMethodError])
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/article/required/show', object: subject).
            ordered.
            and_raise(NoMethodError)
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/article/show', object: subject).
            ordered.
            and_raise(RuntimeError)
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/show', object: subject).
            ordered
          subject.render(template: template)
        end

        it 'stops rendering chain once we sucessfully render a template' do
          subject = described_class.new(object, translator: translator, partial_prefixes: ['article/required', 'article'], presentation_context: 'show', template_missing_exception: [RuntimeError, NoMethodError])
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/article/required/show', object: subject).
            ordered.
            and_raise(NoMethodError)
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/article/show', object: subject).
            ordered
          expect(template).to_not receive(:render).
            with(partial: 'hydramata/works/base/show', object: subject)
          subject.render(template: template)
        end

        it 'raises exception if we are rendering as general as possible' do
          subject = described_class.new(object, translator: translator, presentation_context: 'show')
          expect(template).to receive(:render).
            with(partial: 'hydramata/works/base/show', object: subject).
            and_raise(RuntimeError)
          expect { subject.render(template: template) }.
            to raise_error(RuntimeError)
        end
      end
    end
  end
end
