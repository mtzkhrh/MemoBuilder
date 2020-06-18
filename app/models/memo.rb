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

	# 独自バリデーション
	validate :associate_valid?
	validate :check_tag_list_size
	validate :check_tag_name_length

	def associate_valid?
		error_msg= "メモは必ず家か部屋に入れてください"
		errors.add(:base,error_msg) unless house_id || room_id
	end
	def check_tag_list_size
		errors.add(:base,"タグは5個までです")if tag_list.size > 5
	end
	def check_tag_name_length
		error_msg = "タグが長すぎます。全体で30文字以下にしてください"
		errors.add(:base,error_msg) if tag_list.join.length > 30
	end

	# 指定のユーザにストックされているか？
	def stocked_by?(user)
		stocks.where(user_id: user.id).exists?
	end
	# 指定のユーザにいいねされているか？
	def liked_by?(user)
		likes.where(user_id: user.id).exists?
	end

	scope :resent,			 -> { order(updated_at: :desc)}
	scope :with_tags,    -> { preload(:tags)}
	# 友達が見れるメモ（自分のみ以外のメモ）
	scope :only_friends, -> { where.not(range: "自分のみ")}
	# 公開されたメモのみ
	scope :open,				 -> { where(range: "公開")}

end
