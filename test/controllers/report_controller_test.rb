require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get form" do
    get :form
    assert_response :success
  end

end
