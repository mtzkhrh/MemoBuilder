class Room < ApplicationRecord
  has_many :memos, dependent: :destroy

  belongs_to :house
  belongs_to :user

  counter_culture :house

  validates :user_id,  presence: true
  validates :house_id, presence: true
  validates :name, presence: true, length: { maximum: 40 }

  scope :resent, -> { order(updated_at: :desc) }
  scope :with_memo, -> { preload(:memos) }

end
