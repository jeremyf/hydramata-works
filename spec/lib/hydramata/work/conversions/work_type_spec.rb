require 'fast_helper'
require 'hydramata/work/conversions/work_type'
require 'hydramata/work/linters/implement_work_type_interface_matcher'

module Hydramata
  module Work
    describe Conversions do
      include Conversions

      context '#WorkType' do
        it 'should convert a String to a WorkType object' do
          expect(WorkType('hello')).to implement_work_type_interface
        end

        it 'should convert a Symbol to a WorkType object' do
          expect(WorkType(:hello)).to implement_work_type_interface
        end

        it 'should return the same work_type if a WorkType is given' do
          work_type = WorkType(:hello)
          expect(WorkType(work_type).object_id).to eq(work_type.object_id)
        end

        it 'should convert a "well-formed" Hash to a WorkType object' do
          expect(WorkType(identity: 'hello')).to implement_work_type_interface
        end

        it 'should convert a "#to_work_type" to a WorkType object' do
          stored_object = double('Object', to_work_type: WorkType.new)
          expect(WorkType(stored_object)).to implement_work_type_interface
        end

        it 'should raise an error if the Hash is not "well-formed"' do
          expect { WorkType(other: 'hello') }.to raise_error
        end

        it 'should raise an error object is unexpected' do
          expect { WorkType([]) }.to raise_error
        end
      end
    end
  end
end
