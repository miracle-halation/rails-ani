class Room < ApplicationRecord
	has_one_attached :image
	with_options presence: true do
		validates :name
		validates :description
		validates :leader
	end
end
