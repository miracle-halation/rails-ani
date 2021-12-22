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
  has_many :messages
  has_many :friend_relationships, foreign_key: 'friend_id', class_name: 'Friend', dependent: :destroy
  has_many :applicant_relationships, foreign_key: 'applicant_id', class_name: 'Friend', dependent: :destroy
  has_many :friends, through: :friend_relationships, source: :applicant
  has_many :applicants, through: :applicant_relationships, source: :friend
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

  def friend?(other_id)
    friend = applicant_relationships.find_by(friend_id: other_id)
    friend.blank?
  end

  def accept?(other_id)
    friend = friend_relationships.find_by(applicant_id: other_id)
    friend.accept
  end

  def approval_pending(current_user, other_id)
    applicant_relationships.create(applicant_id: current_user, friend_id: other_id)
  end

  def accept!(current_user, other)
    own = friend_relationships.where('(applicant_id = ?) AND (friend_id = ?) AND (accept = ?)', other.id, current_user, false)
    own.update(accept: true)
    friend = applicant_relationships.where('(applicant_id = ?) AND (friend_id = ?) AND (accept = ?)', current_user, other.id,
                                           false)
    if friend.blank?
      applicant_relationships.create(applicant_id: current_user, friend_id: other.id, accept: true)
    else
      friend.update(accept: true)
    end
  end

  def del_friend(current_user, other_id)
    applicant_relationships.where('(applicant_id = ?) AND (friend_id = ?)', current_user, other_id).first.destroy
    friend_relationships.where('(applicant_id = ?) AND (friend_id = ?)', other_id, current_user).first.destroy
  end
end
