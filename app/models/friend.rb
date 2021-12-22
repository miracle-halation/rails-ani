class Friend < ApplicationRecord
  belongs_to :applicant, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  validates :applicant_id, presence: true
  validates :friend_id, presence: true
end
