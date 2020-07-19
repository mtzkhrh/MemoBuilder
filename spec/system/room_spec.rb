require 'rails_helper'
RSpec.describe 'Room', type: :system do
  describe '部屋のテスト' do
    let!(:user) { create(:user) }
    let!(:test_user2) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end
    describe '部屋一覧画面のテスト' do
	    let(:house) { create(:house, user_id: user.id) }
	    let!(:room1) { create(:room, user_id: user.id, house_id: house.id) }
	    let!(:room2) { create(:room, user_id: user.id, house_id: house.id) }
	    let!(:room3) { create(:room, user_id: user.id, house_id: house.id) }

	    before do
	    	visit user_rooms_path(user)
	    end

      context '自分の部屋一覧画面への遷移' do
      	it '遷移できる' do
          expect(current_path).to eq('/users/' + user.id.to_s + '/rooms' )
      	end
      end
      context '他人の部屋一覧画面への遷移' do
      	it '遷移できる' do
      		visit user_rooms_path(test_user2)
          expect(current_path).to eq('/users/' + test_user2.id.to_s + '/rooms')
      	end
      end
    end
  end
end

