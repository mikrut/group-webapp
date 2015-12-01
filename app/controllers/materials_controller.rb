class MaterialsController < ApplicationController
  before_action :can_manage, only: [:update, :delete, :view_update]

  def create
    if request.method_symbol == :post
      uploaded = Material.new(material_params)
      uploaded.user = current_user

      respond_to do |format|
        if uploaded.save
          format.html { redirect_to action: :read, id: uploaded.id }
          format.json { render json: { redirect: url_for(action: :read, id: uploaded.id) } }
        else
          format.html { redirect_to action: :create }
          format.json { render json: uploaded.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def read
    @mat = Material.find(params[:id])
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end

  def view_update
    render 'update'
  end

  def download
    @document = Material.find(params[:id])

    send_file @document.document.path, type: @document.document_content_type, disposition: 'inline'
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end

  def update
    respond_to do |format|
      if @material.update params.require(:material).permit(:title, :description, :discipline_id)
        format.html { redirect_to action: :read, id: @material.id }
        format.json { render json: { redirect: url_for(action: :read, id:  @material.id) } }
      else
        format.html { redirect_to action: :update, id: @material.id }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    @material.delete
    redirect_to action: :list_materials
  end

  def list_materials
    @materials = Material.eager_load(:user, :discipline)
                 .order(created_at: :desc)
  end

  private

  def can_manage
    begin
      @material = Material.find params[:id]
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    unless current_user.admin? || current_user == @material.user
      fail ActionController::RoutingError.new('Not Found')
    end
  end

  def material_params
    params.require(:material).permit(:title, :description, :document, :discipline_id)
  end
end
