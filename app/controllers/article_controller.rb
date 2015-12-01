class ArticleController < ApplicationController
  before_action :can_edit, only: [:view_update, :update, :delete]

  def create
  end

  def new
    article = Article.new params.require(:article).permit(permitted)
    article.author = current_user
    respond_to do |format|
      if article.save
        format.html { redirect_to action: :read, id: article.id }
        format.json do
          render json: {
            redirect: url_for(action: :read, id: article.id)
          }
        end
      else
        format.html { redirect_to action: :create }
        format.json do
          render json: article.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def read
    @article = Article.eager_load(:author, :discipline)
               .find_by_id!(params[:id])
  rescue
    redirect_to action: :listArticles, status: :not_found
  end

  def update
    respond_to do |format|
      rendered = false
      begin
        article = Article.find params[:id]
        if article.update params.require(:article).permit(permitted)
          format.html { redirect_to action: :read, id: article.id }
          format.json do
            render json: {
              redirect: url_for(action: :read, id: article.id)
            }
          end
        else
          format.html { redirect_to action: :update, id: article.id }
          format.json do
            render json: article.errors,
                   status: :unprocessable_entity
          end
        end
      rescue
      end

      unless rendered
        format.html { redirect_to action: :listArticles }
        format.json do
          render json: {
            redirect: url_for(action: :listArticles)
          }
        end
      end
    end
  end

  def view_update
    status = :forbidden
    success = false

    begin
      @article = Article.find params[:id]
      success = true
    rescue
      status = :not_found
    end

    if success
      render 'create'
    else
      redirect_to action: :listArticles, status: status
    end
  end

  def delete
    article = Article.find_by(id: params[:id]) or not_found
    discipline_id = article.discipline_id
    article.delete
    redirect_to controller: :discipline, action: :listPublications,
                id: discipline_id
  end

  def listArticles
    @articles = Article.eager_load(:author, :discipline)
                .order(created_at: :desc)
  end

  private

  def can_edit
    unless logged_in? && current_user.admin?
      redirect_to controller: :user, action: :login, status: :forbidden
    end
  end

  def permitted
    perm = [:title, :contents, :discipline_id]
    perm.push :send_messages if current_user.admin?
    perm
  end
end
