require 'spec_fast_helper'
require 'hydramata/works/conversions/work_type'
require 'hydramata/works/linters/implement_work_type_interface_matcher'

module Hydramata
  module Works
    describe Conversions do
      include Conversions

      context '#WorkType' do
        it 'raises an error if object is not empty' do
          expect{ WorkType(double(:empty? => false)) }.to raise_error
        end
        it 'converts an empty value to a WorkType null object' do
          expect(WorkType()).to implement_work_type_interface.with(:identity, 'unknown')
        end

        it 'converts an Array to a WorkType null object' do
          expect(WorkType([])).to implement_work_type_interface.with(:identity, 'unknown')
        end

        it 'converts Nil to a WorkType null object' do
          expect(WorkType(nil)).to implement_work_type_interface.with(:identity, 'unknown')
        end

        it 'converts a String to a WorkType object' do
          expect(WorkType('hello')).to implement_work_type_interface
        end

        it 'converts a Symbol to a WorkType object' do
          expect(WorkType(:hello)).to implement_work_type_interface
        end

        it 'returns the same work_type if a WorkType is given' do
          work_type = WorkType(:hello)
          expect(WorkType(work_type).object_id).to eq(work_type.object_id)
        end

        it 'converts a "well-formed" Hash to a WorkType object' do
          expect(WorkType(identity: 'hello')).to implement_work_type_interface
        end

        it 'converts a "#to_work_type" to a WorkType object' do
          stored_object = double('Object', to_work_type: WorkType.new)
          expect(WorkType(stored_object)).to implement_work_type_interface
        end

        it 'raises an error if the Hash is not "well-formed"' do
          expect { WorkType(other: 'hello') }.to raise_error
        end

      end
    end
  end
end
