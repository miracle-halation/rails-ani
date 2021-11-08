class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_many :messages
  has_one_attached :image
  with_options presence: true do
    validates :name, length: { maximum: 25 }
    validates :description, length: { maximum: 500 }
    validates :leader
  end

  def join_user(self, user)
    self.users << user
  end

  def depart_user(self, user)
    self.users.delete(user)
  end
end
