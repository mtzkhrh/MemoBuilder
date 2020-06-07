class Stock < ApplicationRecord
	belongs_to :memos
	belongs_to :user

	validates :memo_id, presence: true, uniqueness: {scope: :user_id}
	validates :user_id, presence: true
end
