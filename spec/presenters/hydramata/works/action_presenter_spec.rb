require 'spec_fast_helper'
require 'hydramata/works/action_presenter'

module Hydramata
  module Works
    describe ActionPresenter do
      let(:context) { double('Context', translate: true) }
      let(:action_name) { :create }
      let(:template) { double('Template', submit_tag: true) }
      subject { described_class.new(context: context, action_name: action_name) }

      context '#render' do
        it 'renders a submit tag' do
          expect(context).to receive(:translate).
            with("actions.create.value", default: 'Save changes').
            and_return('Translated')
          expect(template).to receive(:submit_tag).
            with('Translated', { data: true }).
            and_return('My Submit Tag')
          expect(subject.render(template: template, action_options: { data: true })).to eq('My Submit Tag')
        end
      end

      context '#value' do
        it 'translates the action name' do
          expect(context).to receive(:translate).
            with("actions.create.value", default: 'Save changes').
            and_return('Translated')
          expect(subject.value).to eq('Translated')
        end
      end
    end
  end
end
