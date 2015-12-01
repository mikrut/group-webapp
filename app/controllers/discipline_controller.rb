# A controller for learning disciplines
class DisciplineController < ApplicationController
  before_action :check_admin, only: [:delete, :view_update, :update, :delete]

  def create
  end

  def new
    discipline = Discipline.new params.require(:discipline).permit(:name, :description)
    discipline.group = Group.first
    discipline.save

    redirect_to action: :read, id: discipline.id
  end

  def read
    @discipline = Discipline.find_by(id: params[:id]) or not_found
  end

  def view_update
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    render 'update'
  end

  def update
    discipline = Discipline.find_by(id: params[:id]) or not_found
    begin
      discipline.update params.require(:discipline)
        .permit(:name, :description)
      redirect_to action: :read, id: discipline.id
    rescue
      redirect_to '/'
    end
  end

  def delete
    discipline = Discipline.find_by(id: params[:id]) or not_found
    discipline.delete
  end

  def listMaterials
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    @materials = Material.eager_load(:user, :discipline)
                 .where('discipline_id = ?', @discipline.id)
  end

  def listPublications
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    @articles = Article.eager_load(:author, :discipline)
                .where('discipline_id = ?', @discipline.id)
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
