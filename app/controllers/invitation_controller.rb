class InvitationController < ApplicationController
  before_filter :check_admin, except: [:register, :do_register]
  skip_before_filter :authorize, only: [:register, :do_register]
  before_filter :invitation_exists, only: [:register, :do_register]

  def new_invitation
    invitation = Invitation.create params.require(:invitation).permit(:email, :username)
    invitation.save
    invitation.send_invite
    return redirect_to action: :list
  end

  def create
  end

  def list
    @invitations = Invitation.all
  end

  def resend
    begin
      invitation = Invitation.find params[:id]
      invitation.resend
    rescue
    end
  end

  def delete
    begin
      invitation = Invitation.find params[:id]
      invitation.delete
    rescue
      raise ActionController::RoutingError.new('Not Found')
    end
    return redirect_to action: :list
  end

  def register
    @invitation = Invitation.find_by secret_key: params.require(:key)
    if @invitation.nil?
      redirect_to controller: :user, action: :create, status: :forbidden
    end
  end

  def do_register
    invitation = Invitation.find_by secret_key: params.require(:user).require(:key)
    reg_data = params.require(:user).permit(:name, :email, :date_of_birth, :password, :password_confirmation)
    user = User.create reg_data
    begin
      user.save
      invitation.delete
      return redirect_to controller: :user, action: :create
    rescue
      return redirect_to action: :registration, secret_key: invitation.secret_key
    end
  end

  private

  def invitation_exists
    data = params
    data = params[:user] if params.has_key? :user
    invitation = Invitation.find_by secret_key: data.require(:key)
    return redirect_to controller: :user, action: :create if invitation.nil?
  end
end
