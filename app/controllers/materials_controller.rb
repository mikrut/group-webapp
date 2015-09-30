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
    params.require(:material).permit(:title, :description, :document)
  end

  def read
    begin
      @mat = Material.find(params[:id])
    rescue
      redirect_to '/'
    end
  end

  def download
    begin
    @document = Material.find(params[:id])

    send_file @document.document.path, :type => @document.document_content_type, :disposition => 'inline'
    rescue
      redirect_to '/'
    end
  end

  def update
    begin
      mat = Material.find params[:material][:id]
      if mat.user == current_user || current_user.admin?
        mat.update params.require(:material).permit(:title, :description)
      end
      redirect_to action: 'read', id: mat.id
    rescue
      redirect_to '/'
    end
  end

  def delete
  end
end
