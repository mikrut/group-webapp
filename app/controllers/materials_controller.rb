class MaterialsController < ApplicationController
  def create
    if request.method_symbol == :post
      uploaded = Material.new(material_params)
      uploaded.user = current_user
      uploaded.save

      redirect_to action: 'read', id: uploaded.id
    end
  end

  def material_params
    params.require(:material).permit(:title, :description, :document, :discipline_id)
  end

  def read
    begin
      @mat = Material.find(params[:id])
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
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
    begin
      mat = Material.find params[:material][:id]
      if mat.user == current_user || current_user.admin?
        mat.update params.require(:material).permit(:title, :description, :discipline_id)
      end
      redirect_to action: 'read', id: mat.id
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def delete
    begin
      material = Material.find params[:material][:id]
      material.delete if current_user.admin? or current_user == material.user
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def list_materials
    @materials = Material.limit(10)
  end
end
