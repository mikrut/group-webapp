class User < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :name, :email, length: { minimum: 2, maximum: 128 }
  validates :email, uniqueness: { case_sensitive: false }
  validate :email_has_one_atSign?

  before_save { self.email = email.downcase }

  def email_has_one_atSign?
    errors.add(:email, "is not valid") unless (email.count "@") == 1
  end

  enum role: {user: 0, admin: 1}

  has_secure_password

  has_many :materials
  belongs_to :group
end
