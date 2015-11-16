require 'test_helper'

class InfoMailerTest < ActionMailer::TestCase

  test "article_published" do
    mail = InfoMailer.article_published Article.first
    assert_equal "New publication", mail.subject
  end

end
