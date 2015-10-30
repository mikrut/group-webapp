class Absense < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
end
