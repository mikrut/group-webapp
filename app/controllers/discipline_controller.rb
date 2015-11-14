class DisciplineController < ApplicationController
  def create
  end

  def new
    discipline = Discipline.new params.require(:discipline).permit(:name, :description)
    discipline.group = Group.first
    discipline.save

    redirect_to action: :read, id: discipline.id
  end

  def read
    begin
      @discipline = Discipline.find(params[:id])
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def view_update
    begin
      @discipline = Discipline.find(params[:id])
      render 'update'
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    begin
      discipline = Discipline.find(params[:id])
      discipline.update params.require(:discipline).permit(:name, :description)

      redirect_to action: :read, id: discipline.id
    rescue
      redirect_to '/'
    end
  end

  def delete
    if current_user.admin?
      begin
        discipline = Discipline.find(params[:id])
        discipline.delete
      rescue
      end
    end
  end

  def listMaterials
    begin
      @discipline = Discipline.find(params[:id])
      @materials = Material.eager_load(:user, :discipline)
                        .where("discipline_id = ?", @discipline.id)
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def listPublications
    begin
      @discipline = Discipline.find(params[:id])
      @articles = Article.eager_load(:author, :discipline)
                        .where("discipline_id = ?", @discipline.id)
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def listDisciplines
    @disciplines = Discipline.select("disciplines.*,\
      (select count(materials.id) from materials\
       where materials.discipline_id = disciplines.id) materials_count,\
      (select count(articles.id) from articles\
       where articles.discipline_id = disciplines.id) articles_count")
    respond_to do |format|
      format.json
      format.html
    end
  end
end
