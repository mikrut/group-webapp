class Article < ActiveRecord::Base
  validates :title, uniqueness: { case_sensitive: false }
  validates :title, length: {minimum: 2}
  validates :author_id, :discipline_id, presence: true

  belongs_to :author, class_name: 'User'
  belongs_to :discipline

end
