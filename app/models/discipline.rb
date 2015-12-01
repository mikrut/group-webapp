# Class describing a learning discipline
class Discipline < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :name, length: { minimum: 1, maximum: 128 }
  validates :description, length: { maximum: 512 }

  has_many :materials
  has_many :articles
  has_many :lessons
  belongs_to :group

  def less_in_sem
    lessons.inject(0) do |sum, l|
      sum + 17 * (l.occurence_type == weekly ? 2 : 1)
    end
  end
end
