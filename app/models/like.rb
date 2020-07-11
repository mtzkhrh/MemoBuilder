class Like < ApplicationRecord
  belongs_to :user
  belongs_to :memo

  counter_culture :memo

  validates :user_id, presence: true
  validates :memo_id, presence: true, uniqueness: { scope: :user_id }
end
