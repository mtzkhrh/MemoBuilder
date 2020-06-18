class Stock < ApplicationRecord
	belongs_to :memo
	belongs_to :user

	validates :memo_id, presence: true, uniqueness: {scope: :user_id}
	validates :user_id, presence: true

	# 更新順
	scope :resent,			 -> { order(updated_at: :desc)}

end
