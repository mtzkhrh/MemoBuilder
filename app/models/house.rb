class House < ApplicationRecord
	has_many :rooms, dependent: :destroy
	# ルーム内のメモ
	has_many :memos, through: :rooms, dependent: :destroy
	# ハウス内のメモ
	has_many :house_memos, class_name: "Memo", dependent: :destroy

	belongs_to :user

	validates :user_id, presence: true
	validates :name,		presence: true
end
