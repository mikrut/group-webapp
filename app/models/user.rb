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
  has_many :articles, foreign_key: :author_id
  has_many :absenses # Жизненно...
  belongs_to :group

  def absense_count
    self.absenses.count
  end

  def absense_count_disc discipline
    dis_abs = Absense.count_by_sql([
      "SELECT COUNT(*) as cnt FROM absenses\
        LEFT JOIN lessons ON absenses.lesson_id = lessons.id\
        WHERE lessons.discipline_id = ?
        AND absenses.user_id = ?",
        discipline.id,
        self.id
    ])
  end

  def absense_perc
    if Lesson.less_in_sem != 0
      absense_count.to_f / Lesson.less_in_sem
    else
      0
    end
  end

  def absense_perc_disc discipline
    lis = discipline.less_in_sem
    if lis != 0
      absense_count_disc(discipline).to_f / lis
    else
      0
    end
  end
end
