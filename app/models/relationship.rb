class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"
  validates :follower_id, presence: true, uniqueness: {scope: :following_id}
  validates :following_id, presence: true
end
