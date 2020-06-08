class Memo < ApplicationRecord
	#Memoにgemのタグが付随する
	acts_as_taggable_on :tags
	#refileの設定
	attachment :image

	has_many :comments, dependent: :destroy
	has_many :stocks, dependent: :destroy
	has_many :likes,  dependent: :destroy

	belongs_to :user
	#optional: trueでpresenceをオフ
	belongs_to :room, optional: true
	belongs_to :house, optional: true

	enum range:{自分のみ: 0, 友達のみ: 1,公開: 2}

	validates :user_id, presence: true
	validates :title,		presence: true, length:{maximum: 50}
	validates :body, 		presence: true

	#house_idかroom_idが無ければエラー
	# validates :associate_valid?
	# def associate_valid?
	# 	error_msg= "メモは必ずハウスかルームに入れてください"
	# 	errors.add(:house, error_msg) unless house_id || room_id
	# end
end
