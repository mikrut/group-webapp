require 'test_helper'

class GroupControllerTest < ActionController::TestCase
  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get view" do
    get :view
    assert_response :success
  end

end
