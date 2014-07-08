require 'spec_fast_helper'
require 'hydramata/works/conversions/translation_key_fragment'

module Hydramata
  module Works
    describe Conversions do
      include Conversions
      context 'TranslationKeyFragment' do
        context 'successfully converts' do
          it 'a String' do
            expect(TranslationKeyFragment('hello')).to eq('hello')
          end

          it 'to a normalized format' do
            expect(TranslationKeyFragment('Hello World: Welcome')).to eq('hello_world_welcome')
          end

          it 'a Symbol' do
            expect(TranslationKeyFragment(:hello)).to eq('hello')
          end

          it 'a Hash with :to_translation_key_fragment key' do
            object = { to_translation_key_fragment: 'fragment' }
            expect(TranslationKeyFragment(object)).to eq('fragment')
          end

          it 'an object that implements #to_translation_key_fragment' do
            object = double(to_translation_key_fragment: 'fragment')
            expect(TranslationKeyFragment(object)).to eq('fragment')
          end
        end

        context 'will not convert' do
          it 'an unexpected object' do
            expect { TranslationKeyFragment(double) }.to raise_error
          end

          it 'nil' do
            expect { TranslationKeyFragment(nil) }.to raise_error
          end
        end
      end
    end
  end
end
