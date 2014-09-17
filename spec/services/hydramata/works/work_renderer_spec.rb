require 'spec_fast_helper'
require 'hydramata/works/work_renderer'

module Hydramata
  module Works
    describe WorkRenderer do
      let(:work) { double('Work', render: true) }
      let(:presentation_structure) { double('Presentation Structure') }
      let(:template) { double('Template') }
      subject do
        Hydramata::Works::WorkRenderer.new(work: work, format: :html, template: template)
      end

      it 'renders the template based on all the inputs' do
        subject.render
        expect(work).to have_received(:render).with(template)
      end

      it 'defaults to :html format' do
        renderer = Hydramata::Works::WorkRenderer.new(work: work, template: template)
        expect(renderer.format).to eq(:html)
      end
    end
  end
end
