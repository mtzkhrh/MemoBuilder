require 'rails_helper'
RSpec.describe 'Houseモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:house) { build(:house, user_id: user.id)}
    it "user_idとnameが存在すれば有効" do
	    expect(house).to be_valid
	  end
    context 'nameカラム' do
			it "名前がないと無効" do
	    	house.name = ""
		    expect(house.valid?).to eq false
		  end
		  it "40文字以下であること" do
	    	house.name = Faker::Lorem.characters(number:41)
		    expect(house.valid?).to eq false
		  end
    end
  end
end