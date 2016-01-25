# encoding=utf-8
# Class describing a learning discipline
class Discipline < ActiveRecord::Base
  # Проверка присутствия названия дисциплины заданной длины
  validates :name, presence: true, uniqueness: true
  validates :name, length: { minimum: 1, maximum: 128 }
  # Проверка, что описание не превышает заданную длину
  validates :description, length: { maximum: 512 }

  # Дисциплине принадлежат материалы, статьи, пары
  has_many :materials
  has_many :articles
  has_many :lessons
  # Дисциплина читается группе
  belongs_to :group

  # Метод получения числа занятий в семестре
  def less_in_sem
    lessons.inject(0) do |sum, l|
      sum + 17 * (l.occurence_type == weekly ? 2 : 1)
    end
  end
end
