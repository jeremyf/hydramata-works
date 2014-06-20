require 'spec_fast_helper'
require 'hydramata/work/translator'

module Hydramata
  module Work
    describe Translator do
      subject do
        described_class.new(
          base_scope: base_scope,
          translation_service: translation_service,
          translation_service_error: translation_service_error
        )
      end
      let(:base_scope) { ['hydramata', 'work'] }
      let(:scopes) { [['grandparent', 'parent'], ['grandparent']] }
      let(:translation_service) { double('TranslationService', translate: true) }
      let(:translation_service_error) { ArgumentError }

      context '#translate' do
        it 'passes options to the default rendering' do
          expect(translation_service).to receive(:translate).
            with('child', scope: base_scope, default: 'default').
            ordered.
            and_return('With Default')

          expect(subject.translate('child', default: 'default')).to eq('With Default')
        end

        it 'attempts to translate through each scope then finally via the base scope' do
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[0]), raise: true).
            ordered.
            and_raise(translation_service_error)
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[1]), raise: true).
            ordered.
            and_raise(translation_service_error)
          expect(translation_service).to receive(:translate).
            with('child', scope: base_scope, scopes: scopes).
            ordered.
            and_return('My Work Type')

          expect(subject.translate('child', scopes: scopes)).to eq('My Work Type')
        end

        it 'translates through each scope until it finds a match then returns without processing more generic case' do
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[0]), raise: true).
            ordered.
            and_raise(translation_service_error)
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[1]), raise: true).
            ordered.
            and_return('Found Grandparent')
          expect(translation_service).to_not receive(:translate).
            with('child', scope: base_scope)

          expect(subject.translate('child', scopes: scopes)).to eq('Found Grandparent')
        end

        it 'translates through each scope until it finds a match then returns without processing more generic case' do
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[0]), raise: true).
            ordered.
            and_raise(translation_service_error)
          expect(translation_service).to receive(:translate).
            with('child', scope: (base_scope + scopes[1]), raise: true).
            ordered.
            and_raise(translation_service_error)
          expect(translation_service).to_not receive(:translate).
            with('child', scope: base_scope, scopes: scopes).
            ordered.
            and_raise(translation_service_error)

          expect { subject.translate('child', scopes: scopes) }.to raise_error
        end
      end

    end
  end
end
