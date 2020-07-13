require 'rails_helper'
RSpec.describe 'House', type: :system do
  describe '家のテスト' do
    let!(:user) { create(:user) }
    let!(:test_user2) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '家一覧画面のテスト' do
	    let!(:house1) { create(:house, user_id: user.id) }
	    let!(:house2) { create(:house, user_id: user.id) }
	    let!(:house3) { create(:house, user_id: user.id) }

      before do
        visit user_houses_path(user)
      end
      context '自分の家一覧画面への遷移' do
      	it '遷移できる' do
          expect(current_path).to eq('/users/' + user.id.to_s + '/houses' )
      	end
      end
      context '他人の家一覧画面への遷移' do
      	it '遷移できる' do
      		visit user_houses_path(test_user2)
          expect(current_path).to eq('/users/' + test_user2.id.to_s + '/houses')
      	end
      end

      context '表示の確認' do
				it '家の作成フォームが表示される' do
          expect(page).to have_field 'house[name]'
        end
        it '他人の一覧には家作成フォームが表示されない' do
        	visit user_houses_path(test_user2)
          expect(page).not_to have_field 'house[name]'
          expect(current_path).to eq('/users/' + test_user2.id.to_s + '/houses')
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[name_cont]'
        end
        it '並び替えリンクが表示される' do
        	expect(page).to have_link '名前順'
        	expect(page).to have_link '更新順'
        end
        it '「持ち家一覧」が表示される' do
        	expect(page).to have_content '持ち家一覧'
        end
        it '家の名前のリンクが表示される' do
        	expect(page).to have_link house1.name, href: house_path(house1)
        	expect(page).to have_link house2.name, href: house_path(house2)
        	expect(page).to have_link house3.name, href: house_path(house3)
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end
      context '家の作成フォームの確認' do
        let (:test_house) {build(:house)}

        it '作成に成功する' do
          fill_in 'house[name]', with: test_house.name
          click_button '作成'
          expect(page).to have_content test_house.name
        end
        it '作成に失敗する' do
          fill_in 'house[name]', with: ""
          click_button '作成'
          expect(page).to have_content '家を建てられませんでした'

          fill_in 'house[name]', with: Faker::Lorem.characters(number: 41)
          click_button '作成'
          expect(page).to have_content '家を建てられませんでした'
        end
      end
      context '検索フォームの確認' do
        it '検索に成功する' do
          fill_in '検索...', with: house1.name
          click_on 'q[submit]'
          expect(page).to have_content house1.name
          expect(page).not_to have_content house2.name
        end
        it '該当なしの時「見つかりませんでした」を表示する' do
          fill_in '検索...', with: Faker::Lorem.characters(number: 41)
          click_on 'q[submit]'
          expect(page).to have_content '見つかりませんでした'
        end
      end
      context 'リンクの確認' do
        it '各家の部屋一覧に遷移できる' do
          click_link house1.name
          expect(current_path).to eq('/houses/' + house1.id.to_s)

          visit user_houses_path(user)
          click_link house2.name
          expect(current_path).to eq('/houses/' + house2.id.to_s)

          visit user_houses_path(user)
          click_link house3.name
          expect(current_path).to eq('/houses/' + house3.id.to_s)
        end
        it 'マイページに遷移できる' do
          click_link '<< マイページへ'
          expect(current_path).to eq('/users/' + user.id.to_s)
        end
      end
    end
    describe '家の詳細画面のテスト' do
      let(:house) { create(:house, user_id: user.id) }
      let(:room1) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:room2) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:house_memo) { create(:memo, house_id: house.id, user_id: user.id) }
      let!(:room_memo) { create(:memo, room_id: room1.id, user_id: user.id) }
      let!(:test_house) { create(:house, user_id: test_user2.id) }

      before do
        visit house_path(house)
      end

      context '自分の家の詳細画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/houses/' + house.id.to_s )
        end
      end

      context '他人の家の詳細画面への遷移' do
        it '遷移できる' do
          visit house_path(test_house)
          expect(current_path).to eq('/houses/' + test_house.id.to_s )
        end
      end

      context '表示の確認' do
        it 'パンくずリストが表示される' do
          expect(find('.breadcrumb')).to have_content(user.name + " " + house.name )
        end
        it '家のリフォームボタンが表示される' do
          expect(page).to have_link '家のリフォーム', href: edit_house_path(house)
        end
        it '他人の詳細画面にはリフォームボタンが表示されない' do
          visit house_path(test_house)
          expect(page).not_to have_link '家のリフォーム'
          expect(current_path).to eq('/houses/' + test_house.id.to_s )
        end
        it '部屋の作成フォームが表示される' do
          expect(page).to have_field 'room[name]'
        end
        it '他人の詳細画面には家作成フォームが表示されない' do
          visit house_path(test_house)
          expect(page).not_to have_field 'room[name]'
          expect(current_path).to eq('/houses/' + test_house.id.to_s )
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[name_cont]'
          expect(page).to have_field 'q[title_cont]'
        end
        it '並び替えリンクが表示される' do
          expect(page).to have_link '名前順'
          expect(page).to have_link '更新順'
          expect(page).to have_link 'タイトル順'
        end
        it '「〜の部屋一覧」が表示される' do
          expect(page).to have_content house.name + 'の部屋一覧'
        end
        it '部屋の名前のリンクが表示される' do
          expect(page).to have_link room1.name, href: room_path(room1)
          expect(page).to have_link room2.name, href: room_path(room2)
        end
        it '部屋のメモ数と更新日が表示される' do
          expect(find("#room_#{room1.id}")).to have_content "メモ数 (#{room1.memos.size})"
          expect(find("#room_#{room1.id}")).to have_content "#{room1.updated_at.strftime('%Y/%m/%d')} 更新"
          expect(find("#room_#{room2.id}")).to have_content "メモ数 (#{room2.memos.size})"
          expect(find("#room_#{room2.id}")).to have_content "#{room2.updated_at.strftime('%Y/%m/%d')} 更新"
        end
        it '「〜内の投稿一覧」が表示される' do
          expect(page).to have_content house.name + '内の投稿一覧'
        end
        it '投稿のタイトルリンクが表示される' do
          expect(find("#memo_#{house_memo.id}")).to have_link house_memo.title, href: memo_path(house_memo)
        end
        it '家の一覧へのリンクが表示される' do
          expect(page).to have_link '<< 家の一覧へ', href: user_houses_path(user)
        end
      end
    end
  end
end

