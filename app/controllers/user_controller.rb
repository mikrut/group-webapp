class UserController < ApplicationController
  def create
  end

  def login
    user = User.find_by(name: params[:user][:name])
    if user && user.authenticate(params[:user][:password])
      log_in user
      redirect_to action: 'read', id: user.id
    else
      redirect_to '/user/login'
    end
  end

  def read
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to '/'
    end
  end

  def list
    @group = User.order(:name).limit(30).offset(0)
  end

  def update
    @user = User.find(params[:id])
  end

  def updatePOST
    required = [:name, :email, :date_of_birth]
    begin
      if logged_in? and params.has_key? :id and params.has_key? :user then
        user = User.find(params[:id])
        user.update(params[:user]) if (current_user == user or current_user.admin?) and (current_user.admin? == params[:user].has_key?(:role))
      end
    rescue
    end
    redirect_to :action => 'read', id: params[:id]
  end

  def delete
    begin
      if logged_in?
        user = User.find(id: params[:id])
        user.delete if user and (user == current_user or current_user.admin?)
        log_out
      end
    rescue
    end
    redirect_to '/user/login'
  end

  def logout
    log_out
    redirect_to '/user/login'
  end
end
