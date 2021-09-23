class Room < ApplicationRecord
	has_many :users, through: :room_users
	has_many :room_users
	has_one_attached :image
	with_options presence: true do
		validates :name
		validates :description
		validates :leader
	end
end
