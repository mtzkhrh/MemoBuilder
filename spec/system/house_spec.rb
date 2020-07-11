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
          expect(current_path).to eq('/users/' + user.id.to_s +'/houses')
      	end
      end
      context '他人の家一覧画面への遷移' do
      	it '遷移できる' do
      		visit user_houses_path(test_user2)
          expect(current_path).to eq('/users/' + test_user2.id.to_s +'/houses')
      	end
      end

      context '表示の確認' do
				it '家の作成フォームが表示される' do
          expect(page).to have_field 'house[name]'
        end
        it '他人には家作成フォームが表示されない' do
		      visit new_user_session_path
		      fill_in 'user[email]', with: test_user2.email
		      fill_in 'user[password]', with: test_user2.password
		      click_button 'ログイン'
        	visit user_houses_path(user)

          expect(page).not_to have_field 'house[name]'
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
        it '家の名前のリンクが一覧で表示される' do
        	expect(find('.list_item')).to have_link house1.name, house_path(house1)
        	expect(find('.list_item')).to have_link house2.name, house_path(house2)
        	expect(find('.list_item')).to have_link house3.name, house_path(house3)
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end
    end
  end
end

