# Students progress in learning
class Progress < ActiveRecord::Base
  belongs_to :user
  belongs_to :discipline
end
