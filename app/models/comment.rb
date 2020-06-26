class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :memo

  validates :user_id, presence: true
  validates :memo_id, presence: true
  validates :comment, presence: true, length: { maximum: 250 }
end
