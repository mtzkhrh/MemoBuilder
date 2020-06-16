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
	validate :associate_valid?
	def associate_valid?
		error_msg= "メモは必ずハウスかルームに入れてください"
		errors.add(:house, error_msg) unless house_id || room_id
	end

	# 指定のユーザにストックされているか？
	def stocked_by?(user)
		stocks.where(user_id: user.id).exists?
	end

	# 指定のユーザにいいねされているか？
	def liked_by?(user)
		likes.where(user_id: user.id).exists?
	end

	# 更新順
	scope :resent,			 -> { order(updated_at: :desc)}
	# 友達が見れるメモ（自分のみ以外のメモ）
	scope :only_friends, -> { where.not(range: "自分のみ")}
	# 公開されたメモのみ
	scope :open,				 -> { where(range: "公開")}

end
