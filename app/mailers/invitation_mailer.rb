class InvitationMailer < ApplicationMailer
  default from: 'notifications@localhost:3000'

  def invitation_email(invitation)
    @invitation = invitation
    url_params = { key: @invitation.secret_key }
    @url = "http://localhost:3000/invitation/register?#{url_params.to_query}"
    mail to: @invitation.email, subject: 'Register at localhost!'
  end
end
