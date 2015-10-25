class Invitation < ActiveRecord::Base
  has_secure_token :secret_key

  def send_invite
    InvitationMailer.invitation_email(self).deliver_now
  end

  def resend
    secret_key = self.regenerate_secret_key
    self.send_invite
  end
end
