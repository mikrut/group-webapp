class MaterialsController < ApplicationController
  before_filter :can_manage, only: [:update, :delete, :view_update]

  def create
    if request.method_symbol == :post
      uploaded = Material.new(material_params)
      uploaded.user = current_user
      uploaded.save

      redirect_to action: 'read', id: uploaded.id
    end
  end

  def read
    begin
      @mat = Material.find(params[:id])
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def view_update
    render 'update'
  end

  def download
    begin
    @document = Material.find(params[:id])

    send_file @document.document.path, :type => @document.document_content_type, :disposition => 'inline'
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    @material.update params.require(:material).permit(:title, :description, :discipline_id)
    redirect_to action: 'read', id: @material.id
  end

  def delete
    @material.delete
  end

  def list_materials
    @materials = Material.limit(10)
  end

  private

  def can_manage
    begin
      @material = Material.find params[:id]
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    unless current_user.admin? || current_user == @material.user
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def material_params
    params.require(:material).permit(:title, :description, :document, :discipline_id)
  end
end
