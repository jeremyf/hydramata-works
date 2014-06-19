unless defined?(Rails)
  Dir[File.expand_path('../../app/*', __FILE__)].each do |dir|
    puts dir
    $LOAD_PATH << dir
  end
  $LOAD_PATH << File.expand_path('../../lib', __FILE__)

  unless defined?(require_dependency)
    def require_dependency(*files)
      require *files
    end
  end
end