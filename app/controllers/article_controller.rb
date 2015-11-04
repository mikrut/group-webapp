class ArticleController < ApplicationController
  before_action :can_edit, only: [:update, :delete]

  def create
  end

  def new
    article = Article.new params.require(:article).permit(permitted)
    article.author = current_user
    article.save
    redirect_to action: :read, id: article.id
  end

  def read
    begin
      @article = Article.find params[:id]
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    begin
      article = Article.find params[:id]
      article.update params.require(:article).permit(permitted)
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    redirect_to action: :read, id: article.id
  end

  def view_update
    begin
      @article = Article.find params[:id]
      render 'create'
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def delete
    begin
      article = Article.find params[:id]
      discipline_id = article.discipline_id
      article.delete
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    redirect_to controller: :discipline, action: :listPublications,
                id: discipline_id
  end

  def listArticles
    @articles = Article.all
  end

  private

  def can_edit
    unless logged_in? and current_user.admin?
      redirect_to controller: :user, action: :login
    end
  end

  def permitted
    perm = [:title, :contents, :discipline_id]
    perm.push :send_messages if current_user.admin?
    return perm
  end
end
