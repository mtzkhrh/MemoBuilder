require 'rails_helper'
RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
	  it "名前とメールアドレスとパスワードが存在すれば有効" do
	    expect(user).to be_valid
	  end
    context 'nameカラム' do
		  it "nameがないと無効" do
		    user.name = ""
		    expect(user).not_to be_valid
		  end
		end
	  context 'emailカラム' do
	  	it "emailがないと無効" do
		    user.email = ""
		    expect(user).not_to be_valid
		  end
		  it "＠がないと無効" do
		  	user.email = Faker::Lorem.characters(number:30)
		    expect(user).not_to be_valid
		  end
		end
		context 'passwordカラム' do
		  it "パスワードがないと無効" do
		    user.password = ""
		    expect(user).not_to be_valid
		  end
		  it "パスワードが不一致で無効" do
		    user.password_confirmation = ""
		    expect(user).not_to be_valid
		  end
		end
		context 'introductionカラム' do
			it "200文字以下であること" do
        user.introduction = Faker::Lorem.characters(number:201)
        expect(user).not_to be_valid
			end
		end
  end
end