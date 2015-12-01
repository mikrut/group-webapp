# Class describing an invitation to register on a site
class Invitation < ActiveRecord::Base
  has_secure_token :secret_key

  def send_invite
    InvitationMailer.invitation_email(self).deliver_now
  end

  def resend
    regenerate_secret_key
    send_invite
  end
end
