require 'rails_helper'
RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
	  it "nameとemailとpasswordが存在すれば有効" do
	    expect(user.valid?).to eq true
	  end
    context 'nameカラム' do
		  it "nameがないと無効" do
		    user.name = ""
		    expect(user.valid?).to eq false
		  end
		end
	  context 'emailカラム' do
	  	it "emailがないと無効" do
		    user.email = ""
		    expect(user.valid?).to eq false
		  end
		  it "＠がないと無効" do
		  	user.email = Faker::Lorem.characters(number:30)
		    expect(user.valid?).to eq false
		  end
		end
		context 'passwordカラム' do
		  it "パスワードがないと無効" do
		    user.password = ""
		    expect(user.valid?).to eq false
		  end
		  it "パスワードが不一致で無効" do
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

  end

end