require 'rails_helper'
RSpec.describe 'Likeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Memoモデルとの関係' do
      it 'N:1となっている' do
        expect(Like.reflect_on_association(:memo).macro).to eq :belongs_to
      end
    end
  end
end
