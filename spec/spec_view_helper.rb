# I'm deliberately not including this, as I was hoping to keep the views tested
# in extreme isolation.

# Example:
# $ time rspec -r spec/spec_view_helper.rb spec/views/hydramata/works/fieldsets/_edit.html.erb_spec.rb
#
#     real  0m1.228s
#     user  0m1.003s
#     sys   0m0.205s
#
# Compared to `rspec -r spec/spec_slow_helper.rb ./path/to/spec.rb`
#
# Example:
# $ time rspec -r spec/spec_view_helper.rb spec/views/hydramata/works/fieldsets/_edit.html.erb_spec.rb
#
#     real  0m3.417s
#     user  0m2.720s
#     sys   0m0.679s

require 'active_support'
require 'action_view'
require 'action_controller'

require 'active_support/core_ext/hash/reverse_merge'

require 'rspec/rails'
require 'rspec-html-matchers'

ActionController::Base.prepend_view_path(File.expand_path('../../app/views', __FILE__))
