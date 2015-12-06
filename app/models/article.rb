# encoding: utf-8
# Class describing an article: a text posted by user
class Article < ActiveRecord::Base
  after_save :call_mr_postman

  # Проверка уникальности заголовка
  validates :title, uniqueness: { case_sensitive: false }
  # Проверка длины заголовка
  validates :title, length: { minimum: 2, maximum: 128 }
  # Проверка ширины содержимого
  validates :contents, length: { maximum: 128 }
  # Проверка, что автор задан
  validates :author_id, presence: true

  belongs_to :author, class_name: 'User'
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  belongs_to :discipline

  attr_accessor :send_messages

  private

  def call_mr_postman
    InfoMailer.article_published(self).deliver_now if send_messages
  end
end
