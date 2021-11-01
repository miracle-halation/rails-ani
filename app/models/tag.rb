class Tag < ApplicationRecord
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tag
  validates :name, presence: true, length: { maximum: 50 }
end
