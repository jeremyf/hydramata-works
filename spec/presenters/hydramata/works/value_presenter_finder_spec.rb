require 'spec_fast_helper'
require 'hydramata/works/value_presenter_finder'

module Hydramata
  module Works
    describe ValuePresenterFinder do
      context 'with empty input' do
        When(:returned_value) { described_class.call('') }
        Then { returned_value == ValuePresenter }
      end

      context 'with an class name that is in the object graph' do
        Given(:predicate) { double(value_presenter_class_name: 'ValuePresenterFinder') }
        When(:returned_value) { described_class.call(predicate) }
        Then { returned_value == ValuePresenterFinder }
      end

      context 'with a value that can be constantized' do
        Given(:klass_name) { double(constantize: Integer) }
        Given(:predicate) { double(value_presenter_class_name: klass_name) }
        When(:returned_value) { described_class.call(predicate) }
        Then { returned_value == Integer }
      end

      context 'with a non-constantizable' do
        Given(:arbitrary_thing) { double(to_s: 'MissingObjectFromHydramata')}
        Given(:predicate) { double(value_presenter_class_name: arbitrary_thing) }
        When(:returned_value) do
          expect(arbitrary_thing).to receive(:constantize).and_raise(NameError)
          described_class.call(predicate)
        end
        Then { returned_value == ValuePresenter }
      end
    end
  end
end
