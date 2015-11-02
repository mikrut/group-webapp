class UserController < ApplicationController
  skip_before_filter :authorize, only: [:create, :login]

  def create
    return redirect_to action: :read, id: current_user.id if logged_in?
    render layout: 'empty'
  end

  def login
    user = User.find_by(name: params[:user][:name])
    if user && user.authenticate(params[:user][:password])
      log_in user
      redirect_to action: :read, id: user.id
    else
      redirect_to action: :create
    end
  end

  def view_stat
    @user = current_user
    @absenses = {}
    Lesson.all.each do |lesson|
      disc_n = lesson.discipline.name
      @absenses[disc_n] ||= {}
      less_t = lesson.lesson_type
      @absenses[disc_n][less_t] ||= {count: 0, total: 0}
      factor = less_t == 0 ? 1 : 2;
      @absenses[disc_n][less_t][:total] += 17 / factor
    end

    @user.absenses.each do |absense|
      disc_n = absense.lesson.discipline.name
      less_t = absense.lesson.lesson_type
      @absenses[disc_n][less_t][:count] += 1
    end
  end

  def read
    begin
      @user = User.find(params[:id])
      @disciplines = @user.group.disciplines
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
    permitted = [:name, :email, :date_of_birth]
    permitted.push(:role) if current_user.admin?
    begin
      user = User.find(params[:id])
      if (current_user == user or current_user.admin?) then
        user.update(params.require(:user).permit(permitted))
      end
    rescue
    end
    redirect_to :action => 'read', id: params[:id]
  end

  def delete
    begin
      if logged_in?
        user = User.find(id: params[:id])
        user.delete if user == current_user or current_user.admin?
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
