require 'rails_helper'
RSpec.describe 'Roomモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:house) { create(:house, user_id: user.id) }
    let!(:room) { build(:room, user_id: user.id, house_id: house.id) }

    it "user_idとhouse_idとnameが存在すれば有効" do
      expect(room.valid?).to eq true
    end
    context 'nameカラム' do
      it "名前がないと無効" do
        room.name = ""
        expect(room.valid?).to eq false
      end
      it "40文字以下であること" do
        room.name = Faker::Lorem.characters(number: 41)
        expect(room.valid?).to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Houseモデルとの関係' do
      it 'N:1となっている' do
        expect(Room.reflect_on_association(:house).macro).to eq :belongs_to
      end
    end

    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Room.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
