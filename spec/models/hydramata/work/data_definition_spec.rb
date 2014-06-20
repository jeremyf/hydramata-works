# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'spec_fast_helper'
require 'hydramata/work/data_definition'
require 'hydramata/work/linters/implement_data_definition_interface_matcher'

module Hydramata
  module Work
    describe DataDefinition do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_data_definition_interface }

      it 'should initialize via attributes' do
        expect(subject.identity).to eq('My Identity')
      end

      it 'should have a meaningful #to_s' do
        expect(subject.to_s).to eq('My Identity')
      end

      context '#==' do
        subject { described_class.new(identity: 'My Identity') }

        it 'be true if class and identity is equal' do
          other = described_class.new(identity: subject.identity)
          expect(subject == other).to be_truthy
        end

        it 'be false if identity is equal but not class' do
          other = double(identity: subject.identity)
          expect(subject == other).to be_falsey
        end

        it 'be false if class is equal but not identity' do
          other = subject.class.new(identity: "#{subject.identity}1")
          expect(subject == other).to be_falsey
        end
      end

      context '#to_translation_key_fragment' do
        it 'should default to identity if no name is given for application usage' do
          expect(subject.to_translation_key_fragment).to eq subject.identity
        end

        it 'should default to identity if no name is given for application usage' do
          subject = described_class.new(identity: 'My Identity', name_for_application_usage: 'Twonky')
          expect(subject.to_translation_key_fragment).to eq 'Twonky'
        end
      end

    end
  end
end