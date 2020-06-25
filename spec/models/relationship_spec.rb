require 'rails_helper'
RSpec.describe 'Relationshipモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) {create(:user)}
    let!(:relationship) {build(:relationship, follower_id: user.id)}
    it '自分をフォローできない' do
      relationship.following_id = user.id
      expect(relationship.valid?).to eq false
    end
  end
	describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
	end
end