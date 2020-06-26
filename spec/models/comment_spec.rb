require 'rails_helper'
RSpec.describe 'Memoモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:house) { create(:house, user_id: user.id) }
    let(:room) { create(:room, user_id: user.id, house_id: house.id) }
    let(:memo) { create(:memo, user_id: user.id, room_id: room.id) }
    let!(:comment) { build(:comment, memo_id: memo.id, user_id: user.id) }

    it "user_idとmemo_idとcomment本文が存在すれば有効" do
      expect(memo.valid?).to eq true
    end
    context 'commentカラム' do
      it "空でないこと" do
        comment.comment = ""
        expect(comment.valid?).to eq false
      end
      it "250文字以下であること" do
        comment.comment = Faker::Lorem.characters(number: 251)
        expect(comment.valid?).to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Memoモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:memo).macro).to eq :belongs_to
      end
    end
  end
end
