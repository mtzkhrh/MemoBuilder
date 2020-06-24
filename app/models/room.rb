class Room < ApplicationRecord
  has_many :memos, dependent: :destroy

  belongs_to :house
  belongs_to :user

  validates :user_id,  presence: true
  validates :house_id, presence: true
  validates :name, presence: true

  # 更新順
  scope :resent, -> { order(updated_at: :desc) }
end
