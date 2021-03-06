require 'test_helper'

class MaterialsControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test 'should get create' do
    get :create
    assert_response :success
  end

  test 'should get read' do
    get :read, id: rnd_material.id
    assert_response :success
  end

  test 'should get update' do
    log_in some_admin
    get :view_update, id: rnd_material.id
    assert_response :success
  end

  test 'should get list materials' do
    get :list_materials
    assert_response :success
  end

  private

  def rnd_material
    Material.first
  end
end
