class ArticleController < ApplicationController
  before_action :can_edit, only: [:update, :delete]

  def create
  end

  def new
    article = Article.new params.require(:article).permit(permitted)
    article.author = current_user
    respond_to do |format|
      if article.save
        format.html {redirect_to action: :read, id: article.id}
        format.json {render json: {redirect: url_for(action: :read, id: article.id)}}
      else
        format.html {redirect_to action: :create}
        format.json {render json: article.errors, status: :unprocessable_entity}
      end
    end
  end

  def read
    begin
      @article = Article.eager_load(:author, :discipline)
                        .find_by_id!(params[:id])
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    respond_to do |format|
      rendered = false
      begin
        article = Article.find params[:id]
        if article.update params.require(:article).permit(permitted)
          format.html {redirect_to action: :read, id: article.id}
          format.json {render json: {redirect: url_for(action: :read, id: article.id)}}
        else
          format.html {redirect_to action: :update, id: article.id}
          format.json {render json: article.errors, status: :unprocessable_entity}
        end
      rescue
      end

      if not rendered
        format.html {redirect_to action: :listArticles}
        format.json {render json: {redirect: url_for(action: :listArticles)}}
      end
    end
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
    @articles = Article.eager_load(:author, :discipline)
                       .order(created_at: :desc)
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
