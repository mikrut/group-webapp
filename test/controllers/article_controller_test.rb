require 'test_helper'

class ArticleControllerTest < ActionController::TestCase
  def setup
    authorize_some_user
  end

  def teardown
    log_out
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get read" do
    get :read, id: rnd_article.id
    assert_response :success
  end

  test "should get update" do
    log_in get_some_admin
    get :view_update, id: Article.first
    assert_response :success
  end

  test "should get listArticles" do
    get :listArticles
    assert_response :success
  end

  private

  def rnd_article
    Article.first
  end

end
