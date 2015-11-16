require 'test_helper'

class InvitationControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test "admin should get create" do
    log_in get_some_admin
    get :create
    assert_response :success
  end

  test "admin should get list" do
    log_in get_some_admin
    get :list
    assert_response :success
  end

  test "should get register" do
    invitation = Invitation.new email: 'test@example.com', username: 'testusername'
    invitation.save
    get :register, key: invitation.secret_key
    assert_response :success
    invitation.delete
  end

end
