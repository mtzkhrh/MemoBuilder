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

      context '表示の確認' do
				it '部屋の作成フォームが表示される' do
          expect(page).to have_field 'room[name]'
        end
        it '他人の一覧には部屋作成フォームが表示されない' do
        	visit user_rooms_path(test_user2)
          expect(page).not_to have_field 'room[name]'
          expect(current_path).to eq('/users/' + test_user2.id.to_s + '/rooms')
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[name_cont]'
        end
        it '並び替えリンクが表示される' do
        	expect(page).to have_link '名前順'
        	expect(page).to have_link '更新順'
        end
        it '「部屋一覧」が表示される' do
        	expect(page).to have_content '部屋一覧'
        end
        it '部屋の名前のリンクが表示される' do
        	expect(page).to have_link room1.name, href: room_path(room1)
        	expect(page).to have_link room2.name, href: room_path(room2)
        	expect(page).to have_link room3.name, href: room_path(room3)
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end

      context '部屋の作成フォームの確認' do
        let (:test_room) {build(:room)}

        it '作成に成功する' do
        	select(house.name, from: 'room[house_id]')
          fill_in 'room[name]', with: test_room.name
          click_button '作成'
          expect(page).to have_content test_room.name
        end
        it '作成に失敗する' do
          fill_in 'room[name]', with: test_room.name
          click_button '作成'
          expect(page).to have_content '部屋を作成できませんでした'

        	select(house.name, from: 'room[house_id]')
          fill_in 'room[name]', with: ""
          click_button '作成'
          expect(page).to have_content '部屋を作成できませんでした'

        	select(house.name, from: 'room[house_id]')
          fill_in 'room[name]', with: Faker::Lorem.characters(number: 41)
          click_button '作成'
          expect(page).to have_content '部屋を作成できませんでした'
        end
      end

      context '検索フォームの確認' do
        it '検索に成功する' do
          fill_in '検索...', with: room1.name
          click_on 'q[submit]'
          expect(page).to have_content room1.name
          expect(page).not_to have_content room2.name
        end
        it '該当なしの時「見つかりませんでした」を表示する' do
          fill_in '検索...', with: Faker::Lorem.characters(number: 41)
          click_on 'q[submit]'
          expect(page).to have_content '見つかりませんでした'
        end
      end

    end
  end
end

