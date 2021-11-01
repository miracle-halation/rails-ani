# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Rails.application.routes.url_helpers
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :room_users
  has_many :rooms, through: :room_users
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_one_attached :icon
  validates :nickname, presence: true, length: { maximum: 10 }

  def tag_save(savetaglist)
    unless tags.nil?
      user_tags_records = UserTag.where(user_id: id)
      user_tags_records.destroy_all
    end

    savetaglist.each do |tag|
      inspected_tag = Tag.where(name: tag).first_or_create
      tags << inspected_tag
    end
  end

  def icon_url
    icon.attached? ? url_for(icon) : nil
  end
end
