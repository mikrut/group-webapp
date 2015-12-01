require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get create' do
    log_in some_admin
    get :create
    assert_response :success
  end

  test 'should get form by POST' do
    log_in some_admin
    post :form, report: { date: Time.zone.now.strftime('%Y.%m.%d') }
    assert_response :success
  end
end
