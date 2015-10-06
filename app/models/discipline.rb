class Discipline < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :name, length: {minimum: 1, maximum: 128}
  validates :description, length: {maximum: 512}

  has_many :materials
  has_many :articles
end
