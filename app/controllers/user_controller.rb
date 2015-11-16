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
      redirect_to action: :create, status: :forbidden
    end
  end

  def view_stat
    @user = current_user
    @absenses = {}

    Discipline.all.each do |discipline|
      @absenses[discipline.id] = {by_type: {}, percentage: 0, name: discipline.name}
    end

    Lesson.all.each do |lesson|
      disc_id = lesson.discipline_id
      less_t = lesson.lesson_type
      @absenses[disc_id][:by_type][less_t] ||= {count: 0, total: 0}
      factor = less_t == 0 ? 1 : 2;
      @absenses[disc_id][:by_type][less_t][:total] += 17 / factor
    end

    @user.absenses.each do |absense|
      disc_id = absense.lesson.discipline_id
      less_t = absense.lesson.lesson_type
      @absenses[disc_id][:by_type][less_t][:count] += 1
    end

    @absenses.each do |discipline_id, record|
      progress = Progress.find_by ({
        user: @user,
        discipline_id: discipline_id
      })
      percentage = progress ? progress.percentage : 0
      record[:percentage] = percentage
    end
  end

  def read
    begin
      @user = User.find(params[:id])
      @disciplines = @user.group.disciplines
    rescue
      redirect_to '/', status: :not_found
    end
  end

  def list
    @group = User.order(:name).limit(30).offset(0)
  end

  def update
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to '/', status: :not_found
    end
  end

  def updatePOST
    permitted = [:name, :email, :date_of_birth,
                 :first_name, :last_name, :middle_name]
    permitted.push(:role) if current_user.admin?

    respond_to do |format|
      rendered = false
      begin
        @user = User.find(params[:id])
        if (current_user == @user or current_user.admin?) then
          rendered = true
          if @user.update(params.require(:user).permit(permitted))
            format.html {redirect_to action: :read, id: params[:id]}
            format.json {}
          else
            format.html {render action: :update}
            format.json {render json: @user.errors, status: :unprocessable_entity}
          end
        end
      rescue
      end

      if not rendered
        format.html {redirect_to action: :read, id: params[:id], status: :unprocessable_entity}
        format.json {render json: {message: 'Failed'}}
      end
    end
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
