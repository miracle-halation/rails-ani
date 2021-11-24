class Friend < ApplicationRecord
	belongs_to :applicant
	belongs_to :friend_id
	validate :applicant, presence: true
	validate :friend_id, presence: true
end
