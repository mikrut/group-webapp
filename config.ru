# This file is used by Rack-based servers to start the application.

require 'rake'

rake = Rake.application
rake.init
rake.load_rakefile
rake['ts:restart'].invoke()

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
