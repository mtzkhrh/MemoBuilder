class Memo < ApplicationRecord
  # 家と部屋の両方に付随できない
  before_save :decide_parent
  # Memoにgemのタグが付随する
  acts_as_taggable_on :tags
  # refileの設定
  attachment :image

  has_many :comments, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :likes,  dependent: :destroy

  belongs_to :user
  # optional: trueでpresenceをオフ
  belongs_to :room, optional: true
  belongs_to :house, optional: true

  counter_culture :room
  counter_culture [:room, :house], column_name: 'rooms_memos_count'
  counter_culture :house, column_name: 'house_memos_count'

  enum range: { 自分のみ: 0, 友達のみ: 1, 公開: 2 }

  validates :user_id, presence: true
  validates :title,    presence: true, length: { maximum: 50 }
  validates :body,     presence: true

  # 独自バリデーション
  validate :associate_valid?
  validate :check_tag_list_size
  validate :check_tag_name_full_length
  validate :check_tag_name_length

  scope :resent, -> { order(updated_at: :desc) }
  # N+1問題を解消する取得
  scope :with_tags, -> { preload(:tags) }
  scope :with_meta, -> { preload(:comments, :likes) }
  scope :with_user, -> { eager_load(:user) }
  # 公開範囲に合わせた取得
  scope :only_friends, -> { where.not(range: "自分のみ") }
  scope :open, -> { where(range: "公開") }

  def decide_parent
    if house_id && room_id
      self.house_id = nil
    end
  end

  def associate_valid?
    unless house_id || room_id
      error_msg = "メモは必ず家か部屋に入れてください"
      errors.add(:base, error_msg)
    end
  end

  def check_tag_list_size
    errors.add(:base, "タグは5個までです") if tag_list.size > 5
  end

  def check_tag_name_length
    error_msg = "タグ名が長すぎます。（20文字以下）"
    tag_list.each do |tag|
      if tag.length > 20
        errors.add(:base, error_msg)
        break
      end
    end
  end

  def check_tag_name_full_length
    error_msg = "タグが長すぎます。全体で30文字以下にしてください"
    errors.add(:base, error_msg) if tag_list.join.length > 30
  end

  # 指定のユーザにストックされているか？
  def stocked_by?(user)
    stocks.where(user_id: user.id).exists?
  end

  # 指定のユーザにいいねされているか？
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
