class InvitationController < ApplicationController
  before_filter :check_admin, except: [:register_user, :registration]
  skip_before_filter :authorize, only: [:register_user, :registration]
  before_filter :invitation_exists, only: [:register_user, :registration]

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
