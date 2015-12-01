class InvitationController < ApplicationController
  before_action :check_admin, except: [:register, :do_register]
  skip_before_action :authorize, only: [:register, :do_register]
  before_action :invitation_exists, only: [:register, :do_register]

  def new_invitation
    invitation = Invitation.create params.require(:invitation)
                 .permit(:email, :username)
    invitation.save
    invitation.send_invite
    redirect_to action: :list
  end

  def create
  end

  def list
    @invitations = Invitation.all
  end

  def resend
    invitation = Invitation.find_by(id: params[:id]) or not_found
    invitation.resend
  end

  def delete
    invitation = Invitation.find_by(id: params[:id]) or not_found
    invitation.delete
    redirect_to action: :list
  end

  def register
    @invitation = Invitation.find_by secret_key: params.require(:key)
    if @invitation.nil?
      redirect_to controller: :user, action: :create, status: :forbidden
    end
  end

  def do_register
    invitation = Invitation.find_by(secret_key: params.require(:user)
                                                .require(:key))
    reg_data = params.require(:user).permit(:name, :email,
                                            :date_of_birth, :password, :password_confirmation)
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
    data = params[:user] if params.key? :user
    invitation = Invitation.find_by secret_key: data.require(:key)
    return redirect_to controller: :user, action: :create if invitation.nil?
  end
end
