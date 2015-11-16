class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize

  protect_from_forgery with: :exception
  include SessionHelper

  private

  def authorize
    redirect_to  controller: :user,
                 action: :login, status: :forbidden unless logged_in?
  end

  def check_admin
    unless logged_in?
      redirect_to controller: :user, action: :login, status: :forbidden
    else
      unless current_user.admin?
        redirect_to controller: :user, action: :read,
                    id: current_user.id,  status: :forbidden
      end
    end
  end
end
