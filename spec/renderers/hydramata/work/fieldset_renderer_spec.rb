# require 'fast_helper'
# require 'hydramata/work/fieldset_renderer'


# module Hydramata
#   module Work
#     describe FieldsetRenderer do
#       let(:context) { :show }
#       subject { described_class.new(context: context) }

#       it 'should render the template based on all the inputs' do
#         subject.render
#         template_name = "hello/world/#{context}"

#         expect(template).to have_received(:render).
#         with(
#           file: template_name,
#           locals: { context.to_sym => instance_of(PresentedEntity) }
#         )
#       end

#     end
#   end
# end
