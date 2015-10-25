#encoding=utf-8

class User < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :name, :email, length: { minimum: 2, maximum: 128 }
  validates :email, uniqueness: { case_sensitive: false }
  validate :email_has_one_atSign?

  before_save do
    self.email = email.downcase
    self.group = Group.first
  end

  def email_has_one_atSign?
    errors.add(:email, "is not valid") unless (email.count "@") == 1
  end

  enum role: {user: 0, admin: 1}

  has_secure_password

  has_many :materials
  has_many :articles
  has_many :absenses # Жизненно...
  belongs_to :group
end
