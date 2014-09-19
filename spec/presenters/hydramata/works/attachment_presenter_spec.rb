require 'spec_fast_helper'
require 'hydramata/works/attachment_presenter'
require 'hydramata/works/work'
require 'hydramata/works/predicate'

module Hydramata
  module Works
    describe AttachmentPresenter do
      let(:work) { 'a work type' }
      let(:predicate) { 'a predicate' }
      let(:value) { double('Value', to_s: 'HELLO WORLD', raw_object: raw_object) }
      let(:raw_object) { double('Raw Object', file_uid: 'my_file_uid') }
      let(:renderer) { double('Renderer', call: true) }
      let(:template) { double('Template') }
      let(:remote_url_builder) { double('Remote URL Builder', call: true) }
      subject { described_class.new(value: value, work: work, predicate: predicate, renderer: renderer, remote_url_builder: remote_url_builder) }

      it 'has a url' do
        expect(remote_url_builder).to receive(:call).with(raw_object.file_uid).and_return("THE URL")
        expect(subject.url).to eq("THE URL")
      end

      it 'renders via the template' do
        expect(renderer).to receive(:call).with(template, kind_of(Hash)).and_return('YES')
        expect(subject.render(template)).to eq('YES')
      end

      it 'renders the value as a string' do
        expect(renderer).to receive(:call).with(template, kind_of(Hash)).and_yield
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
