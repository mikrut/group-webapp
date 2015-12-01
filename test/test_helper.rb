ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../../app/helpers/session_helper.rb', __FILE__)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in
  # alphabetical order.
  fixtures :all
  include SessionHelper

  # Add more helper methods to be used by all tests here...

  def authorize_some_user
    user = User.first
    log_in user
  end

  def some_admin
    User.find_by(role: User.roles[:admin])
  end
end
