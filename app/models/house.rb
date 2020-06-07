class House < ApplicationRecord
	has_many :rooms, dependent: :destroy
	has_many :memos, dependent: :destroy

	belongs_to :user

	validates :user_id, presence: true
	validates :name,		presence: true
end
