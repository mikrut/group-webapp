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
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def listPublications
    begin
      @discipline = Discipline.find(params[:id])
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def listDisciplines
    @disciplines = Discipline.all.map {|d| [d.name, d.id]}
    render :json => {code: 200, data: @disciplines}
  end
end
