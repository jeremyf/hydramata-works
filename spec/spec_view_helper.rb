# I'm deliberately not including this, as I was hoping to keep the views tested
# in extreme isolation.
# require 'spec_fast_helper'

require 'active_support'
require 'action_view'
require 'action_controller'

require 'active_support/core_ext/hash/reverse_merge'

require 'rspec/rails'
require 'rspec-html-matchers'

ActionController::Base.prepend_view_path(File.expand_path('../../app/views', __FILE__))
