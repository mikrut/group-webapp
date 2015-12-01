require 'test_helper'

class ArticleControllerTest < ActionController::TestCase
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

  test 'unauthed cant get create' do
    log_out
    get :create
    assert_response :forbidden
  end

  test 'should get read' do
    get :read, id: rnd_article.id
    assert_response :success
  end

  test 'unauthed cant get read' do
    log_out
    get :read, id: rnd_article.id
    assert_response :forbidden
  end

  test 'should get update' do
    log_in some_admin
    get :view_update, id: Article.first
    assert_response :success
  end

  test 'unauthed cant get update' do
    log_out
    get :view_update, id: Article.first
    assert_response :forbidden
  end

  test 'user cant get update' do
    article = Article.first
    user = User.where(role: User.roles[:user]).where
           .not(id: article.author.id).first
    log_in user
    get :view_update, id: article.id
    assert_response :forbidden
  end

  test 'creator cant get update' do
    user = User.where(role: User.roles[:user]).joins(:articles).first
    article = user.articles[0]
    log_in user
    get :view_update, id: article.id
    assert_response :forbidden
  end

  test 'should get listArticles' do
    get :listArticles
    assert_response :success
  end

  test 'unauthorized shouldnt get listArticles' do
    log_out
    get :listArticles
    assert_response :forbidden
  end

  private

  def rnd_article
    Article.first
  end
end
