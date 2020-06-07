class Stock < ApplicationRecord
	belongs_to :memos
	belongs_to :user

	validates :memo_id, presence: true
	validates :user_id, presence: true
end
