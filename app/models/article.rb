class Article < ActiveRecord::Base
  after_save :call_mr_postman

  validates :title, uniqueness: { case_sensitive: false }
  validates :title, length: {minimum: 2, maximum: 128}
  validates :contents, length: {maximum: 128}
  validates :author_id, presence: true

  belongs_to :author, class_name: 'User'
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  belongs_to :discipline

  attr_accessor :send_messages

  private

  def call_mr_postman
    InfoMailer.article_published(self).deliver_now if self.send_messages
  end
end
