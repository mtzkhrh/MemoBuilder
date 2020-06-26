require 'rails_helper'
RSpec.describe 'Houseモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:house) { build(:house, user_id: user.id) }

    it "user_idとnameが存在すれば有効" do
      expect(house.valid?).to eq true
    end
    context 'nameカラム' do
      it "名前がないと無効" do
        house.name = ""
        expect(house.valid?).to eq false
      end
      it "40文字以下であること" do
        house.name = Faker::Lorem.characters(number: 41)
        expect(house.valid?).to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(House.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(House.reflect_on_association(:rooms).macro).to eq :has_many
      end
    end
  end
end
