require 'test_helper'

class UserControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get create' do
    log_out
    get :create
    assert_response :success
  end

  test 'should get read' do
    get :read, id: current_user.id
    assert_response :success
  end

  test 'should get stat' do
    get :view_stat
    assert_response :success
  end

  test 'should get update' do
    get :update, id: current_user.id
    assert_response :success
  end
end
