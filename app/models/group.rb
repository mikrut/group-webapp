# encoding: utf-8
# Class describing a learning group
class Group < ActiveRecord::Base
  attr_accessor :title
  attr_reader :course
  validates :faculty, :cathedra, :semester, :index, :faculty_name,
            :cathedra_name, presence: true
  validates :faculty_name, :cathedra_name, length: { maximum: 128 }

  validates :semester, inclusion: 1..12
  validates :index, inclusion: 1..5
  validates :cathedra, inclusion: 1..20

  has_many :disciplines
  has_many :users
  has_many :students, class_name: :User
  has_many :lessons

  public

  def title=(value)
    regex = /
      (?<faculty>[a-zA-Zа-яА-Я]{1,3})
      (?<cathedra>\d+)-(?<semester>\d{1,2})
      (?<index>\d)
    /x
    data = regex.match(value)
    data.names.each { |k| self[k] = data[k] }
  end

  def title
    "#{faculty}#{cathedra}-#{semester}#{index}"
  end

  def course
    (semester + 1) / 2
  end
end
