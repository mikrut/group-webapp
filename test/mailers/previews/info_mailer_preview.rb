# Preview all emails at http://localhost:3000/rails/mailers/info_mailer
class InfoMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/info_mailer/article_published
  def article_published
    InfoMailer.article_published
  end
end
