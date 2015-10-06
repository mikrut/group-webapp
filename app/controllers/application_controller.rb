class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize

  protect_from_forgery with: :exception
  include SessionHelper

  private

  def authorize
    redirect_to controller: :user, action: :login unless logged_in?
  end
end
