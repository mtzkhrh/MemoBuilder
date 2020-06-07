class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #refileの設定
  attachment :profile_image
  #Memoのタグのオーナーに設定
  acts_as_tagger

	has_many :memos,  dependent: :destroy
	has_many :houses, dependent: :destroy
	has_many :rooms, 	dependent: :destroy
	has_many :stocks, dependent: :destroy
	has_many :comments, dependent: :destroy
	#自分の立ち位置
	has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
	has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
	#自分にとっての相手の立場
	has_many :followings, through: :follower, source: :followed, dependent: :destroy
	has_many :followers,  through: :followed, source: :follower, dependent: :destroy
	has_many :likes

	def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_user.include?(user)
  end
	# お互いにフォローしている人を配列でピックアップ
	def friends
		followings && followers
	end
end
