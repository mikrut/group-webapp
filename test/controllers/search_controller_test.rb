require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get find' do
    get :find
    assert_response :success
  end
end
