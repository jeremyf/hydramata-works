# This helper provides at least a ~x3 speed increase over the 'spec_slow_helper'.
#
# The idea being that some tests have very few dependencies.
#
# Example:
# $ time rspec -r spec/spec_fast_helper.rb spec/lib/hydramata-work_spec.rb
#
#     real  0m1.188s
#     user  0m0.979s
#     sys   0m0.204s
#
# Compared to `rspec -r spec/spec_slow_helper.rb ./path/to/spec.rb`
#
# Example:
# $ time rspec -r spec/spec_slow_helper.rb spec/lib/hydramata-work_spec.rb
#
#     real  0m3.491s
#     user  0m2.800s
#     sys   0m0.667s

unless defined?(Rails) # If we are in a Rails context this is overkill.
  Dir[File.expand_path('../../app/*', __FILE__)].each do |dir|
    $LOAD_PATH << dir
  end
  $LOAD_PATH << File.expand_path('../../lib', __FILE__)

  unless defined?(require_dependency)
    def require_dependency(*files)
      require *files
    end
  end
end