require 'rails_helper'
RSpec.describe 'User', type: :system do
  describe 'ユーザー認証のテスト' do
    describe 'ユーザー新規登録' do
      before do
        visit new_user_registration_path
      end

      context '新規登録画面に遷移' do
        it '新規登録に成功する' do
          fill_in 'user[name]', with: Faker::Internet.username(specifier: 5)
          fill_in 'user[email]', with: Faker::Internet.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'アカウントを作成'

          expect(page).to have_content 'アカウント登録が完了しました。'
        end
        it '新規登録に失敗する' do
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: ''
          click_button 'アカウントを作成'

          expect(page).to have_content 'エラー'
        end
      end

      context 'トップページに遷移' do
        before do
          visit root_path
        end

        it '新規登録に成功する' do
          fill_in 'user[name]', with: Faker::Internet.username(specifier: 5)
          fill_in 'user[email]', with: Faker::Internet.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'アカウントを作成'

          expect(page).to have_content 'アカウント登録が完了しました。'
        end
        it '新規登録に失敗する' do
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          fill_in 'user[password_confirmation]', with: ''
          click_button 'アカウントを作成'

          expect(page).to have_content 'エラー'
        end
      end
    end

    describe 'ユーザーログイン' do
      let(:user) { create(:user) }

      before do
        visit new_user_session_path
      end

      context 'ログイン画面に遷移' do
        it 'ログインに成功する' do
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'ログイン'

          expect(page).to have_content 'ログインしました。'
        end

        it 'ログインに失敗する' do
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          click_button 'ログイン'

          expect(current_path).to eq(new_user_session_path)
        end
      end
    end
  end

  describe 'ユーザのテスト' do
    let!(:user) { create(:user) }
    let!(:test_user2) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe 'サイドバーのテスト' do
      context '表示の確認' do
        it '画像が表示される' do
          expect(page).to have_css('img.profile_image')
        end
        it '名前が表示される' do
          expect(page).to have_content(user.name)
        end
        it '自己紹介が表示される' do
          expect(page).to have_content(user.introduction)
        end
        it '編集リンクが表示される' do
          visit user_path(user)
          expect(page).to have_link '編集', href: edit_user_path(user)
        end
      end
    end

    describe '編集のテスト' do
      before do
        visit edit_user_path(user)
      end

      context '自分の編集画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
        end
      end

      context '他人の編集画面への遷移' do
        it '遷移できない' do
          visit edit_user_path(test_user2)
          expect(current_path).not_to eq('/users/' + test_user2.id.to_s + '/edit')
        end
      end

      context '表示の確認' do
        it '名前編集フォームに自分の名前が表示される' do
          expect(page).to have_field 'user[name]', with: user.name
        end
        it '画像編集フォームが表示される' do
          expect(page).to have_field 'user[profile_image]'
        end
        it '自己紹介編集フォームに自分の自己紹介が表示される' do
          expect(page).to have_field 'user[introduction]', with: user.introduction
        end
      end

      context 'フォームの確認' do
        let(:edit_user) { build(:user) }

        it '編集に成功する' do
          fill_in 'user[name]', with: edit_user.name
          fill_in 'user[introduction]', with: edit_user.introduction
          click_button '更新する'
          expect(page).to have_content '登録情報を更新しました'
          expect(page).to have_content edit_user.name
          expect(page).to have_content edit_user.introduction
          expect(current_path).to eq('/users/' + user.id.to_s)
        end
        it '編集に失敗する' do
          fill_in 'user[name]', with: ''
          fill_in 'user[introduction]', with: edit_user.introduction
          click_button '更新する'
          expect(page).to have_content 'エラー'
          expect(current_path).to eq('/users/' + user.id.to_s)
          expect(User.find(user.id).introduction).not_to eq(edit_user.introduction)
        end
      end
    end

    describe '一覧画面のテスト' do
      before do
        visit users_path
      end

      context '表示の確認' do
        it '全ユーザ一覧と表示される' do
          expect(page).to have_content('全ユーザ一覧')
        end
        it '自分と他の人の画像が表示される' do
          # サイドバーの１枚とリストの２枚
          expect(all('img').size).to eq(3)
        end
        it '自分と他の人の名前が表示される' do
          expect(page).to have_content user.name
          expect(page).to have_content test_user2.name
        end
        it 'ユーザのリンクが表示される' do
          expect(page).to have_link user.name, href: user_path(user)
          expect(page).to have_link test_user2.name, href: user_path(test_user2)
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[name_cont]'
        end
      end

      context '友達ボタンの表示の確認' do
        it '自分をフォローするリンクは表示されない' do
          expect(page).not_to eq(have_link('', href: user_relationships_path(user)))
        end
        it 'お互いフォローしていない時は「友達申請する」' do
          expect(page).to have_link '友達申請する', href: user_relationships_path(test_user2)
        end
        it '自分のみフォローしている時は「友達申請中」' do
          user.follow(test_user2.id)
          visit users_path
          expect(user.followings).to include(test_user2)
          expect(page).to have_link '友達申請中', href: user_relationships_path(test_user2)
        end
        it '相手からのみフォローしている時は「友達申請が来ています」' do
          test_user2.follow(user.id)
          visit users_path
          expect(test_user2.followings).to include(user)
          expect(page).to have_link '友達申請が来ています', href: user_relationships_path(test_user2)
        end
        it 'お互いフォローしていると「友達」' do
          user.follow(test_user2.id)
          test_user2.follow(user.id)
          expect(user.friends?(test_user2)).to eq true
          expect(page).to have_link '友達', href: user_relationships_path(test_user2)
        end
      end

      context '検索機能のテスト' do
        it '検索に成功する' do
          fill_in 'q[name_cont]', with: test_user2.name
          click_button 'q[submit]'
          expect(page).to have_content test_user2.name
        end
        it '該当なしの時「見つかりませんでした」を表示する' do
          fill_in 'q[name_cont]', with: Faker::Lorem.characters(number: 21)
          click_button 'q[submit]'
          expect(page).to have_content '見つかりませんでした'
        end
      end
    end

    describe 'マイページ画面のテスト' do
      let(:house) { create(:house, user_id: user.id) }
      let(:room) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:memo1) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:memo2) { create(:memo, room_id: room.id, user_id: user.id) }
      let(:test_user_house) { create(:house, user_id: test_user2.id) }
      let(:test_user_room) { create(:room, user_id: test_user2.id, house_id: test_user_house.id) }
      let!(:open_memo) { create(:memo, user_id: test_user2.id, room_id: test_user_room.id, range: '公開') }
      let!(:close_memo) { create(:memo, user_id: test_user2.id, room_id: test_user_room.id) }

      before do
        visit user_path(user)
      end

      context '他人のマイページ画面に遷移' do
        it '非公開のメモは表示されない' do
          visit user_path(test_user2)
          expect(page).to have_content open_memo.title
          expect(page).not_to have_content close_memo.title
        end
      end

      context '表示の確認' do
        it '「持ち家ピックアップ」が表示される' do
          expect(page).to have_content '持ち家ピックアップ'
        end
        it '持ち家のリスト表示される' do
          expect(page).to have_content house.name
        end
        it '持ち家一覧リンクが表示される' do
          expect(page).to have_link '持ち家一覧 >>', href: user_houses_path(user)
        end
        it '「最近の使用タグ一覧」が表示される' do
          expect(page).to have_content '最近の使用タグ一覧'
        end
        it '使用したタグの名前リンクが表示される' do
          expect(find('.tags_list')).to have_link memo1.tag_list[0]
          expect(find('.tags_list')).to have_link memo1.tag_list[1]
          expect(find('.tags_list')).to have_link memo1.tag_list[2]
          expect(find('.tags_list')).to have_link memo2.tag_list[0]
          expect(find('.tags_list')).to have_link memo2.tag_list[1]
          expect(find('.tags_list')).to have_link memo2.tag_list[2]
        end
        it '使用タグ一覧リンクが表示される' do
          expect(page).to have_link '使用タグ一覧 >>', href: user_tags_path(user)
        end
        it '「最近の投稿リスト」が表示される' do
          expect(page).to have_content '最近の投稿リスト'
        end
        it '投稿の一覧が表示される' do
          expect(page).to have_link memo1.title, href: memo_path(memo1)
          expect(page).to have_link memo2.title, href: memo_path(memo2)
        end
        it '投稿一覧リンクが表示される' do
          expect(page).to have_link '投稿一覧 >>', href: user_memos_path(user)
        end
      end
    end

    describe '友達一覧画面のテスト' do
      context '自分の友達一覧画面への遷移' do
        it '遷移できる' do
          visit relationships_user_path(user)
          expect(current_path).to eq('/users/' + user.id.to_s + '/relationships')
        end
      end

      context '他人の友達一覧画面への遷移' do
        it '遷移できない' do
          visit relationships_user_path(test_user2)
          expect(current_path).not_to eq('/users/' + test_user2.id.to_s + '/relationships')
        end
      end

      context '表示の確認' do
        before do
          visit relationships_user_path(user)
        end

        it '友達一覧が表示される' do
          expect(page).to have_content '友達一覧'
        end
        it '承認待ち一覧が表示される' do
          expect(page).to have_content '承認待ち一覧'
        end
        it '申請一覧が表示される' do
          expect(page).to have_content '申請一覧'
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[name_cont]'
        end
      end

      context 'ユーザの表示の確認' do
        let(:test_user3) { create(:user) }
        let(:test_user4) { create(:user) }

        before do
          user.follow(test_user2.id)
          user.follow(test_user3.id)
          test_user2.follow(user.id)
          test_user4.follow(user.id)
          visit relationships_user_path(user)
        end

        context '友達一覧のユーザ表示' do
          it '友達のユーザが表示される' do
            expect(user.friends?(test_user2)).to eq true
            expect(find('#friends')).to have_content test_user2.name
          end
          it '友達以外のユーザは表示されない' do
            expect(user.friends?(test_user3)).to eq false
            expect(user.friends?(test_user4)).to eq false
            expect(find('#friends')).not_to have_content test_user3.name
            expect(find('#friends')).not_to have_content test_user4.name
          end
        end

        context '承認待ち一覧のユーザ表示' do
          it '承認待ちのユーザが表示される' do
            expect(user.following?(test_user3)).to eq true
            expect(user.friends?(test_user3)).to eq false
            expect(find('#followings')).to have_content test_user3.name
          end
          it '承認待ち以外のユーザは表示されない' do
            expect(user.friends?(test_user2)).to eq true
            expect(user.following?(test_user4)).to eq false
            expect(find('#followings')).not_to have_content test_user2.name
            expect(find('#followings')).not_to have_content test_user4.name
          end
        end

        context '申請一覧のユーザ表示' do
          it '申請を送ってきたユーザが表示される' do
            expect(test_user4.following?(user)).to eq true
            expect(user.friends?(test_user4)).to eq false
            expect(find('#followers')).to have_content test_user4.name
          end
          it '申請を送ってきていないユーザは表示されない' do
            expect(user.friends?(test_user2)).to eq true
            expect(test_user3.following?(user)).to eq false
            expect(find('#followers')).not_to have_content test_user2.name
            expect(find('#followers')).not_to have_content test_user3.name
          end
        end

        context '検索機能のテスト' do
          it '検索に成功する' do
            fill_in 'q[name_cont]', with: test_user2.name
            click_button 'q[submit]'
            expect(page).to have_content test_user2.name
            expect(page).not_to have_content test_user3.name
          end
          it '該当なしの時「見つかりませんでした」を表示する' do
            fill_in 'q[name_cont]', with: Faker::Lorem.characters(number: 21)
            click_button 'q[submit]'
            expect(page).to have_content '見つかりませんでした'
          end
        end
      end
    end

    describe 'ストック一覧画面のテスト' do
      let!(:house) { create(:house, user_id: user.id) }
      let!(:room) { create(:room, user_id: user.id, house_id: house.id) }
      let!(:memo) { create(:memo, room_id: room.id, user_id: user.id) }

      before do
        create(:stock, user_id: user.id, memo_id: memo.id)
        visit stocks_user_path(user)
      end

      context '表示の確認' do
        it '「ストック一覧」が表示される' do
          expect(page).to have_content 'ストック一覧'
        end
        it 'ストックされたメモのタイトルリンクが表示される' do
          expect(page).to have_link memo.title, href: memo_path(memo)
        end
        it '投稿したユーザリンクが表示される' do
          expect(find('.list_item')).to have_link user.name, href: user_path(user)
        end
        it '投稿のLikeの数が表示される' do
          expect(find('.list_item')).to have_content memo.likes.size
        end
        it '投稿のコメント数が表示される' do
          expect(find('.list_item')).to have_content memo.comments.size
        end
        it '検索フォームが表示される' do
          expect(page).to have_field '検索...'
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end

      context '検索フォームの確認' do
        let!(:memo1) { create(:memo, room_id: room.id, user_id: user.id) }
        let!(:memo2) { create(:memo, room_id: room.id, user_id: user.id) }

        before do
          create(:stock, user_id: user.id, memo_id: memo1.id)
          create(:stock, user_id: user.id, memo_id: memo2.id)
        end

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
    end
  end
end
