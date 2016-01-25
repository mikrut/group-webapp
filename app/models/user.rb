# encoding=utf-8
# Class describing a student
class User < ActiveRecord::Base
  # Проверки для E-mail и имени
  validates :name, :email, presence: true
  validates :name, :email, length: { minimum: 2, maximum: 128 }
  validates :email, uniqueness: { case_sensitive: false }
  validate :email_has_one_at_sign?

  # Перед сохранением переводим e-mail в нижний регистр и добавляем группу
  before_save do
    self.email = email.downcase
    self.group = Group.first
  end

  def email_has_one_at_sign?
    errors.add(:email, 'is not valid') unless (email.count '@') == 1
  end

  # Имеется два типа пользователей: обычный и администратор
  enum role: { user: 0, admin: 1 }

  has_secure_password

  # Ассоциации модели в БД
  has_many :materials
  has_many :articles, foreign_key: :author_id
  has_many :absenses
  belongs_to :group

  # Далее приведены методы для сбора статистики по пользователю

  def absense_count
    absenses.count
  end

  def absense_count_disc(discipline)
    Absense.count_by_sql([
      'SELECT COUNT(*) as cnt FROM absenses\
       LEFT JOIN lessons ON absenses.lesson_id = lessons.id\
       WHERE lessons.discipline_id = ?
       AND absenses.user_id = ?',
      discipline.id,
      id
    ])
  end

  def absense_perc
    if Lesson.less_in_sem != 0
      absense_count.to_f / Lesson.less_in_sem
    else
      0
    end
  end

  def absense_perc_disc(discipline)
    lis = discipline.less_in_sem
    if lis != 0
      absense_count_disc(discipline).to_f / lis
    else
      0
    end
  end
end
