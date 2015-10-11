require 'test_helper'

class ScheduleControllerTest < ActionController::TestCase
  test "should get read" do
    get :read
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get updateItem" do
    get :updateItem
    assert_response :success
  end

end
