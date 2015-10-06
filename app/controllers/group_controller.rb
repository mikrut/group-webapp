class GroupController < ApplicationController
  def update
    if current_user.admin?
      group = Group.first
      group.update(params.require(:group).permit(:semester, :cathedra, :faculty, :faculty_name, :cathedra_name, :index, :title))
      redirect_to action: :view
    end
  end

  def view
    @group = Group.first
  end
end
