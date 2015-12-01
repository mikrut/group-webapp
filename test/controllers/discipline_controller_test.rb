require 'test_helper'

class DisciplineControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  attr_accessor :rnd_discipline

  test 'should get create' do
    get :create
    assert_response :success
  end

  test 'should get read' do
    get :read, id: rnd_discipline.id
    assert_response :success
  end

  test 'should get update' do
    log_in some_admin
    get :view_update, id: rnd_discipline.id
    assert_response :success
  end

  test 'should get listMaterials' do
    get :listMaterials, id: rnd_discipline.id
    assert_response :success
  end

  test 'should get listPublications' do
    get :listPublications, id: rnd_discipline.id
    assert_response :success
  end

  test 'should get listDisciplines' do
    get :listDisciplines
    assert_response :success
  end

  private

  def rnd_discipline
    Discipline.first
  end
end
