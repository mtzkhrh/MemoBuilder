require 'rails_helper'
RSpec.describe 'Memoモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:house) { create(:house, user_id: user.id) }
    let(:room) { create(:room, user_id: user.id, house_id: house.id) }
    let!(:memo) { build(:memo, user_id: user.id, house_id: house.id, room_id: room.id) }

    it "user_idとhouse_idとnameが存在すれば有効" do
      expect(memo.valid?).to eq true
    end
    context 'titleカラム' do
      it "名前がないと無効" do
        memo.title = ""
        expect(memo.valid?).to eq false
      end
      it "50文字以下であること" do
        memo.title = Faker::Lorem.characters(number: 51)
        expect(memo.valid?).to eq false
      end
    end

    context 'bodyカラム' do
      it "本文がないと無効" do
        memo.body = ""
        expect(memo.valid?).to eq false
      end
    end

    context 'tagsカラム' do
      it "5個以下であること" do
        memo.tag_list = %w(one two three four five six)
        expect(memo.valid?).to eq false
      end
      it "タグの名前が20文字以下であること" do
        memo.tag_list = Faker::Lorem.characters(number: 21)
        expect(memo.valid?).to eq false
      end
      it "タグ全体で30文字以下であること" do
        memo.tag_list = [
          Faker::Lorem.characters(number: 15),
          Faker::Lorem.characters(number: 16),
        ]
        expect(memo.valid?).to eq false
      end
    end

    context 'アソシエーションの可否' do
      it "家か部屋のどちらかに所属していること" do
        memo.house_id = nil
        memo.room_id = nil
        expect(memo.valid?).to eq false
      end
      it "家と部屋の両方に所属している場合はsave時に家IDを削除すること" do
        memo.save
        expect(memo.house_id).to eq nil
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Roomモデルとの関係' do
      it 'N:1となっている' do
        expect(Memo.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end

    context 'Houseモデルとの関係' do
      it 'N:1となっている' do
        expect(Memo.reflect_on_association(:house).macro).to eq :belongs_to
      end
    end

    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Memo.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Memo.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(Memo.reflect_on_association(:likes).macro).to eq :has_many
      end
    end

    context 'Stockモデルとの関係' do
      it '1:Nとなっている' do
        expect(Memo.reflect_on_association(:stocks).macro).to eq :has_many
      end
    end
  end
end
