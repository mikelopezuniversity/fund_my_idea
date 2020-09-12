class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_one_attached :thumbnail
  has_many :comments, as: :commentable

  scope :active, ->{ where(status: "active") }
  scope :inactive, ->{ where(status: "inactive") }

  def active?
    status == "active"
  end

  def inactive
    status == "inactive"
  end
end
