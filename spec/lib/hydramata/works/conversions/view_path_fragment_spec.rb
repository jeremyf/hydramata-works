require 'spec_fast_helper'
require 'hydramata/works/conversions/view_path_fragment'

module Hydramata
  module Works
    describe Conversions do
      include Conversions
      context 'ViewPathFragment' do
        context 'successfully converts' do
          it 'a String' do
            expect(ViewPathFragment('hello')).to eq('hello')
          end

          it 'to a normalized format' do
            expect(ViewPathFragment('Hello World: Welcome')).to eq('hello_world_welcome')
          end

          it 'a Symbol' do
            expect(ViewPathFragment(:hello)).to eq('hello')
          end

          it 'a Hash with :to_view_path_fragment key' do
            object = { to_view_path_fragment: 'fragment' }
            expect(ViewPathFragment(object)).to eq('fragment')
          end

          it 'an object that implements #to_view_path_fragment' do
            object = double(to_view_path_fragment: 'fragment')
            expect(ViewPathFragment(object)).to eq('fragment')
          end
        end

        context 'will not convert' do
          it 'an unexpected object' do
            expect { ViewPathFragment(double) }.to raise_error
          end

          it 'nil' do
            expect { ViewPathFragment(nil) }.to raise_error
          end
        end
      end
    end
  end
end
