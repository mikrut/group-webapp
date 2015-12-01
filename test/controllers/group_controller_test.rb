require 'test_helper'

class GroupControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get update' do
    log_in some_admin
    get :view_update
    assert_response :success
  end

  test 'should get view' do
    get :view
    assert_response :success
  end
end
