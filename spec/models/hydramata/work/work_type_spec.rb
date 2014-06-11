# Instead of using spec_helper, I'm using the twice as fast custom helper
# for active record objects.
require 'active_record_spec_helper'
require 'hydramata/work/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'

module Hydramata
  module Work
    describe WorkType do
      subject { described_class.new(identity: 'My Identity') }
      it { should implement_work_type_interface }

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

    end
  end
end
