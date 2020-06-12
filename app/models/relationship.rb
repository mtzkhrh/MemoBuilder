class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  validates :follower_id, presence: true, uniqueness: {scope: :following_id}
  validates :following_id, presence: true
  validate :check_user

  # 自分をフォローできない
  def check_user
		error_msg= "自分自身をフォローできません"
		errors.add(:following_id, error_msg) if follower_id == following_id
  end

end
