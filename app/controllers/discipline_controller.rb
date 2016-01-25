# encoding=utf-8
# A controller for learning disciplines
class DisciplineController < ApplicationController
  before_action :check_admin, only: [:delete, :view_update, :update, :delete]

  # Получение страницы создания дисциплины
  def create
  end

  # Создание новой дисциплины
  def new
    discipline = Discipline.new params.require(:discipline).permit(:name, :description)
    discipline.group = Group.first
    discipline.save

    redirect_to action: :read, id: discipline.id
  end

  # Получение информации по дисциплине
  def read
    @discipline = Discipline.find_by(id: params[:id]) or not_found
  end

  # Показ страницы редактирования дисциплины
  def view_update
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    render 'update'
  end

  # Обновление информации о дисциплине
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

  # Удаление дисцплины
  def delete
    discipline = Discipline.find_by(id: params[:id]) or not_found
    discipline.delete
  end

  # Получение списка файлов
  def listMaterials
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    @materials = Material.eager_load(:user, :discipline)
                 .where('discipline_id = ?', @discipline.id)
  end

  # Получение списка публикаций
  def listPublications
    @discipline = Discipline.find_by(id: params[:id]) or not_found
    @articles = Article.eager_load(:author, :discipline)
                .where('discipline_id = ?', @discipline.id)
  end

  # Получение списка дисциплин
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
