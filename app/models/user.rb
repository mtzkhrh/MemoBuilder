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
	has_many :stock_memos, through: :stocks, source: :memo
	has_many :comments, dependent: :destroy
	#自分の立ち位置
	has_many :follower, class_name: "Relationship",
											foreign_key: "follower_id", dependent: :destroy
	has_many :followed, class_name: "Relationship",
											foreign_key: "following_id", dependent: :destroy
	#自分にとっての相手の立場
	has_many :followings, through: :follower, source: :following
	has_many :followers,  through: :followed, source: :follower
	has_many :likes

	validates :name, presence: true
	validates :introduction, length:{maximum: 200}


	def follow(user_id)
    follower.create(following_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(following_id: user_id).destroy
  end

  def following?(user)
    followings.pluck(:id).include?(user.id)
  end
	# お互いにフォローしている人を配列でピックアップ
	#自分のフォロワーを探して自分のフォローしているひとを探している
	def friends
		User.where(id: followed.select(:follower_id))
				.where(id: follower.select(:following_id))
	end

	def friends?(user)
		friends.include?(user)
	end

	# フォロワーとフォロイーを足して重複(friends)を全て消して改めてfriendsを足す
	# def all_relationships
	# 	self.followers + self.followings - self.friends + self.friends
	# end
end
