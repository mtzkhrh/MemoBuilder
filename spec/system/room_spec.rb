require 'rails_helper'
RSpec.describe 'Room', type: :system do
  describe '部屋のテスト' do
    let!(:user) { create(:user) }
    let!(:test_user2) { create(:user) }
    let(:house) { create(:house, user_id: user.id) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end
    describe '部屋一覧画面のテスト' do
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
        it 'パンくずリストが表示される' do
          expect(find('.breadcrumb')).to have_content(user.name)
        end
				it '部屋の作成フォームが表示される' do
        	expect(page).to have_select 'room[house_id]'
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

      context 'リンクの確認' do
        it '各部屋に遷移できる' do
          click_link room1.name
          expect(current_path).to eq('/rooms/' + room1.id.to_s)

          visit user_rooms_path(user)
          click_link room2.name
          expect(current_path).to eq('/rooms/' + room2.id.to_s)

          visit user_rooms_path(user)
          click_link room3.name
          expect(current_path).to eq('/rooms/' + room3.id.to_s)
        end
        it 'マイページに遷移できる' do
          click_link '<< マイページへ'
          expect(current_path).to eq('/users/' + user.id.to_s)
        end
      end
    end

    describe '部屋の詳細画面のテスト' do
	    let(:room) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:memo1) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:memo2) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:memo3) { create(:memo, room_id: room.id, user_id: user.id) }
	    let(:test_house) { create(:house, user_id: test_user2.id) }
	    let(:test_room) { create(:room, user_id: test_user2.id, house_id: test_house.id) }

	    let(:test_house) { create(:house, user_id: test_user2.id) }
	    let(:test_room) { create(:room, user_id: test_user2.id, house_id: test_house.id) }

      before do
      	visit room_path(room)
      end

      context '自分の部屋の詳細画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq("/rooms/#{room.id}")
        end
      end

      context '他人の部屋の詳細画面への遷移' do
        it '遷移できる' do
          visit room_path(test_room)
          expect(current_path).to eq("/rooms/#{test_room.id}")
        end
      end

      context '表示の確認' do
        it 'パンくずリストが表示される' do
          expect(find('.breadcrumb')).to have_content(user.name + " " + house.name + " " + room.name )
        end
        it '部屋のリフォームボタンが表示される' do
          expect(page).to have_link '部屋のリフォーム', href: edit_room_path(room)
        end
        it '他人の詳細画面にはリフォームボタンが表示されない' do
          visit room_path(test_room)
          expect(page).not_to have_link '部屋のリフォーム'
          expect(current_path).to eq('/rooms/' + test_room.id.to_s )
        end
        it '投稿作成ボタンが表示される' do
          expect(page).to have_link '投稿を作成する'
        end
        it '他人の詳細画面には投稿作成が表示されない' do
          visit room_path(test_room)
          expect(page).not_to have_field '投稿を作成する'
          expect(current_path).to eq('/rooms/' + test_room.id.to_s )
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[title_cont]'
        end
        it '並び替えリンクが表示される' do
          expect(page).to have_link 'タイトル順'
          expect(page).to have_link '更新順'
        end
        it '「〜内の投稿一覧」が表示される' do
          expect(page).to have_content room.name + '内の投稿一覧'
        end
        it '投稿タイトルのリンクが表示される' do
          expect(page).to have_link memo1.title, href: memo_path(memo1)
          expect(page).to have_link memo2.title, href: memo_path(memo2)
          expect(page).to have_link memo3.title, href: memo_path(memo3)
        end
        it '公開範囲と更新日が表示される' do
          expect(find("#memo_#{memo1.id}")).to have_content memo1.range
          expect(find("#memo_#{memo1.id}")).to have_content "#{memo1.updated_at.strftime('%Y/%m/%d')}更新"
          expect(find("#memo_#{memo2.id}")).to have_content memo2.range
          expect(find("#memo_#{memo2.id}")).to have_content "#{memo2.updated_at.strftime('%Y/%m/%d')}更新"
        end
        it '「部屋を出る」リンクが表示される' do
          expect(page).to have_link '<< 部屋を出る', href: house_path(room.house)
        end
      end

      context '検索フォームの確認' do
        it '検索に成功する' do
          fill_in '検索...', with: memo1.title
          click_on 'q[submit]'
          expect(page).to have_content memo1.title
          expect(page).not_to have_content memo2.title
        end
        it '該当なしの時「見つかりませんでした」を表示する' do
          fill_in '検索...', with: Faker::Lorem.characters(number: 51)
          click_on 'q[submit]'
          expect(page).to have_content '見つかりませんでした'
        end
      end

      context 'リンクの確認' do
        it '部屋の編集画面に遷移できる' do
          click_on '部屋のリフォーム'
          expect(current_path).to eq("/rooms/#{room.id}/edit")
        end
        it 'メモの詳細画面に遷移できる' do
          click_link memo1.title
          expect(current_path).to eq("/memos/#{memo1.id}")

          visit room_path(room)
          click_link memo2.title
          expect(current_path).to eq("/memos/#{memo2.id}")

          visit room_path(room)
          click_link memo3.title
          expect(current_path).to eq("/memos/#{memo3.id}")
        end
        it '家の詳細画面に遷移する' do
          click_link "<< 部屋を出る"
          expect(current_path).to eq("/houses/#{house.id}")
        end
      end
    end

    describe '部屋の編集画面のテスト' do
	    let!(:room) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:test_house) {create(:house, user_id: user.id)}
	    let(:test_house2) { create(:house, user_id: test_user2.id) }
	    let!(:test_room2) { create(:room,  user_id: test_user2.id, house_id: test_house2.id) }

	    before do
	    	visit edit_room_path(room)
	    end

	    context '自分の部屋の編集画面への遷移' do
        it '遷移できる' do
        	expect(current_path).to eq("/rooms/#{room.id}/edit")
        end
	    end

	    context '他人の部屋の編集画面への遷移' do
        it '遷移できない' do
          visit edit_room_path(test_room2)
          expect(current_path).not_to eq("/rooms/#{test_room2.id}/edit")
        end
      end

      context '表示の確認' do
        it 'パンくずリストが表示される' do
          expect(find('.breadcrumb')).to have_content(user.name + " " + house.name + " " + room.name )
        end
        it '「〜のリフォーム」が表示される' do
          expect(page).to have_content("#{room.name}のリフォーム")
        end
        it '名前フォームが表示される' do
          expect(page).to have_field('room[name]')
        end
        it '名前フォームに部屋の名前が表示される' do
          expect(page).to have_field('room[name]'), with: room.name
        end
        it '家のセレクトボックスが表示される' do
        	expect(page).to have_select 'room[house_id]'
        end
        it '家のセレクトボックスで今の家が表示される' do
        	expect(page).to have_select 'room[house_id]', text: house.name
        end
        it '更新ボタンが表示される' do
          expect(page).to have_button('更新')
        end
        it '戻るリンクが表示される' do
          expect(page).to have_link('<< 戻る'),href: room_path(room)
        end
        it '削除ボタンが表示される' do
          expect(page).to have_link("削除する")
        end
      end

      context 'フォームの確認' do
        let (:test_room) {build(:room)}

				it '更新に成功する' do
        	select(test_house.name, from: 'room[house_id]')
          click_on '更新'
          expect(page).to have_content("部屋を改装しました")
          expect(Room.find(room.id).house_id).to eq(test_house.id)

		    	visit edit_room_path(room)
          fill_in 'room[name]', with: test_room.name
          click_on '更新'
          expect(page).to have_content("部屋を改装しました")
          expect(current_path).to eq("/rooms/#{room.id}")
          expect(user.rooms.pluck(:name)).to include(test_room.name)
        end
        it '更新に失敗する' do
          fill_in 'room[name]', with: " "
          click_on '更新'
          expect(page).to have_content("部屋を改装できませんでした")
        end
      end
    end
  end
end

