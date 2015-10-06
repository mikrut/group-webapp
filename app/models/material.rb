class Material < ActiveRecord::Base
  validates :title, :description, :user, presence: true
  validates :title, uniqueness: true
  validates :title, :description, length: {minimum: 1, maximum: 128}

  has_attached_file :document,
    :path => ":rails_root/uploads/:class/:id/:basename:extension",
    :url  => '/materials/download/:id'

  validates_attachment_presence :document
  validates_attachment_size :document, :less_than => 20.megabytes

  do_not_validate_attachment_file_type :document

  belongs_to :user
end
