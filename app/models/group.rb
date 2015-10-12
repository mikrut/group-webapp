# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessor :title
  validates :faculty, :cathedra, :semester, :index, presence: true

  has_many :disciplines
  has_many :users
  has_many :students, class_name: :User
  has_many :lessons

  public
  def title=(value)
    regex = /(?<faculty>[a-zA-Zа-яА-Я]{1,3})(?<cathedra>\d+)-(?<semester>\d{1,2})(?<index>\d)/
    data = regex.match(value)
    data.names.each {|k| write_attribute k, data[k]}
  end

  def title
    "#{faculty}#{cathedra}-#{semester}#{index}"
  end
end
