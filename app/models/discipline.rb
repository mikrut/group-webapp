class Discipline < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :title, length: {minimum: 1, maximum: 128}
  validates :description, length: {maximum: 512}
end
