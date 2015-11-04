class InfoMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.info_mailer.article_published.subject
  #
  def article_published(article)
    @article = article
    @subject = "New publication"
    User.all.each do |user|
      @user = user
      mail to: @user.email, subject: @subject
    end
  end
end
