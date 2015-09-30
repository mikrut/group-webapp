require 'test_helper'

class DisciplineControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get read" do
    get :read
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get listMaterials" do
    get :listMaterials
    assert_response :success
  end

  test "should get listPublications" do
    get :listPublications
    assert_response :success
  end

end
