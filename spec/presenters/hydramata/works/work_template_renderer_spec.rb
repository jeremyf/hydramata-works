require 'spec_fast_helper'
require 'hydramata/works/work_template_renderer'

module Hydramata
  module Works
    describe WorkTemplateRenderer do
      let(:object) { double('Object', partial_prefixes: ['article/required', 'article'], view_path_slug_for_object: 'base', presentation_context: 'show') }
      let(:template) { double('Template', render: true)}
      subject { described_class.new(object, template_missing_exception: [RuntimeError, NoMethodError]) }

      context '#call' do

        it 'handles a partial_prefixes calling in less and less specificity' do
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/required/show').
            ordered.
            and_raise(NoMethodError)
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/show').
            ordered.
            and_raise(RuntimeError)
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/show').
            ordered
          subject.call(template: template)
        end

        it 'stops calling chain once we sucessfully call a template' do
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/required/show').
            ordered.
            and_raise(NoMethodError)
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/show').
            ordered
          expect(template).to_not receive(:call).
            with(object: object, partial: 'hydramata/works/base/show')
          subject.call(template: template)
        end

        it 'raises exception if we are calling as general as possible' do
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/required/show').
            ordered.
            and_raise(NoMethodError)
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/article/show').
            ordered.
            and_raise(RuntimeError)
          expect(template).to receive(:render).
            with(object: object, partial: 'hydramata/works/base/show').
            ordered.
            and_raise(RuntimeError)
          expect { subject.call(template: template) }.
            to raise_error(RuntimeError)
        end
      end
    end
  end
end
