require 'test_helper'

class ScheduleControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get read' do
    get :read
    assert_response :success
  end

  test 'should get update' do
    log_in some_admin
    get :update
    assert_response :success
  end
end
