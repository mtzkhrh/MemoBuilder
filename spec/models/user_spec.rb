require 'rails_helper'
RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
	  it "nameとemailとpasswordが存在すれば有効" do
	    expect(user.valid?).to eq true
	  end
    context 'nameカラム' do
		  it "空欄でないこと" do
		    user.name = ""
		    expect(user.valid?).to eq false
		  end
      it "20文字以下であること" do
        user.name = Faker::Lorem.characters(number:21)
        expect(user.valid?).to eq false
      end
		end
	  context 'emailカラム' do
	  	it "空欄でないこと" do
		    user.email = ""
		    expect(user.valid?).to eq false
		  end
		  it "＠があること" do
		  	user.email = Faker::Lorem.characters(number:30)
		    expect(user.valid?).to eq false
		  end
		end
		context 'passwordカラム' do
		  it "空欄でないこと" do
		    user.password = ""
		    expect(user.valid?).to eq false
		  end
		  it "パスワードが不一致でないこと" do
		    user.password_confirmation = ""
		    expect(user.valid?).to eq false
		  end
		end
		context 'introductionカラム' do
			it "200文字以下であること" do
        user.introduction = Faker::Lorem.characters(number:201)
		    expect(user.valid?).to eq false
			end
		end
  end
  describe 'アソシエーションのテスト' do
    context 'Houseモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:houses).macro).to eq :has_many
      end
    end
    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:rooms).macro).to eq :has_many
      end
    end
    context 'Memoモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:memos).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    context 'Stockモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:stocks).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '受動的関係と1:Nとなっている' do
        expect(User.reflect_on_association(:followed).macro).to eq :has_many
      end
      it '能動的関係と1:Nとなっている' do
        expect(User.reflect_on_association(:follower).macro).to eq :has_many
      end
    end
  end
  describe 'メソッドのテスト' do
    let(:user){ create(:user) }
    let(:test_user2){ create(:user) }
    before do
      user.follow(test_user2.id)
      test_user2.follow(user.id)
    end
    it 'followメソッド' do
      expect(user.followings).to include(test_user2)
    end
    it 'unfollowメソッド' do
      user.unfollow(test_user2.id)
      expect(user.followings).not_to include(test_user2)
    end
    it 'following?メソッド' do
      expect(user.following?(test_user2)).to eq true
    end
    it 'friendsメソッド' do
      expect(user.friends).to include(test_user2)
    end
    it 'friends?メソッド' do
      expect(user.friends?(test_user2)).to eq true
    end
  end
end