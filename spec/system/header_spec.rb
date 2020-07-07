require 'rails_helper'
RSpec.describe 'Header', type: :system do
  describe 'ヘッダーのテスト' do
    before do
      visit root_path
    end

    describe 'ログインしていない時' do
      context '表示の確認' do
        it 'タイトルが表示される' do
          expect(page).to have_link 'MemoBuilder', href: root_path
        end
        it 'Aboutが表示される' do
          expect(page).to have_link 'About', href: about_path
        end
        it 'サインインが表示される' do
          expect(page).to have_link 'サインイン', href: new_user_registration_path
        end
        it 'ログインが表示される' do
          expect(page).to have_link 'ログイン', href: new_user_session_path
        end
      end

      context 'リンクの確認' do
        it 'トップページに遷移する' do
          click_on 'MemoBuilder'
          expect(current_path).to eq '/'
        end
        it 'アバウトページに遷移する' do
          click_on 'About'
          expect(current_path).to eq '/about'
        end
        it 'サインインページに遷移する' do
          click_on 'サインイン'
          expect(current_path).to eq '/users/sign_up'
        end
        it 'ログインページに遷移する' do
          click_on 'ログイン'
          expect(current_path).to eq '/users/sign_in'
        end
      end
    end

    describe '会員ログイン時' do
      let!(:user) { create(:user) }

      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit root_path
      end

      context '表示の確認' do
        it 'タイトルが表示される' do
          expect(page).to have_link 'MemoBuilder', href: root_path
        end
        it '検索フォームが表示される' do
          expect(page).to have_field '公開投稿から検索...'
        end
        it '新規投稿へのリンクが表示される' do
          expect(page).to have_link '投稿する', href: new_user_memo_path(user)
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link 'マイページ', href: user_path(user)
        end
        it 'ログアウトリンクが表示される' do
          expect(page).to have_link 'ログアウト', href: destroy_user_session_path
        end
        it '一覧リストが表示される' do
          expect(page).to have_link '一覧リスト'
        end
        context 'ドロップダウンリストの表示の確認', js: true do
          before do
            click_on '一覧リスト'
          end

          it '家一覧が表示される' do
            expect(page).to have_link '家一覧', href: user_houses_path(user)
          end
          it '部屋一覧が表示される' do
            expect(page).to have_link '部屋一覧', href: user_rooms_path(user)
          end
          it '投稿一覧が表示される' do
            expect(page).to have_link '投稿一覧', href: user_memos_path(user)
          end
          it 'ストック一覧が表示される' do
            expect(page).to have_link 'ストック一覧', href: stocks_user_path(user)
          end
          it '友達一覧が表示される' do
            expect(page).to have_link '友達一覧', href: relationships_user_path(user)
          end
          it 'ユーザ一覧が表示される' do
            expect(page).to have_link 'ユーザ一覧', href: users_path
          end
          it '公開投稿一覧が表示される' do
            expect(page).to have_link '公開投稿一覧', href: memos_all_path
          end
        end
      end

      context 'リンクの確認' do
        it 'トップページに遷移する' do
          click_on 'MemoBuilder'
          expect(current_path).to eq '/'
        end
        it '新規投稿ページに遷移する' do
          click_on '投稿する'
          expect(current_path).to eq '/users/' + user.id.to_s + '/memos/new'
        end
        it 'マイページに遷移する' do
          click_on 'マイページ'
          expect(current_path).to eq '/users/' + user.id.to_s
        end
        it 'ログアウトする' do
          click_on 'ログアウト'
          expect(current_path).to eq '/users/sign_in'
        end
        context 'ドロップダウンリストのリンクの確認', js: true do
          before do
            click_on '一覧リスト'
          end

          it '持ち家一覧に遷移する' do
            click_on '家一覧'
            expect(current_path).to eq '/users/' + user.id.to_s + '/houses'
          end
          it '部屋一覧に遷移する' do
            click_on '部屋一覧'
            expect(current_path).to eq '/users/' + user.id.to_s + '/rooms'
          end
          it '投稿一覧に遷移する' do
            click_on '投稿一覧'
            expect(current_path).to eq '/users/' + user.id.to_s + '/memos'
          end
          it 'ストック一覧に遷移する' do
            click_on 'ストック一覧'
            expect(current_path).to eq '/users/' + user.id.to_s + '/stocks'
          end
          it '友達一覧に遷移する' do
            click_on '友達一覧'
            expect(current_path).to eq '/users/' + user.id.to_s + '/relationships'
          end
          it 'ユーザ一覧に遷移する' do
            click_on 'ユーザ一覧'
            expect(current_path).to eq '/users'
          end
          it '公開投稿一覧に遷移する' do
            click_on '公開投稿一覧'
            expect(current_path).to eq '/memos/all'
          end
        end
      end
    end

    describe '管理者ログイン時' do
      let(:admin) { create(:admin) }
      let!(:user) { create(:user) }

      before do
        visit new_admin_session_path
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
      end

      context '表示の確認' do
        it 'タイトルが表示される' do
          expect(page).to have_link 'MemoBuilder', href: root_path
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[title_cont]'
        end
        it '管理者トップが表示される' do
          expect(page).to have_link '管理者TOP', href: admin_path
        end
        it 'ユーザ一覧リンクが表示される' do
          expect(page).to have_link 'ユーザ一覧', href: admins_users_path
        end
        it '投稿一覧リンクが表示される' do
          expect(page).to have_link '投稿一覧', href: admins_memos_path
        end
        it 'ログアウトが表示される' do
          expect(page).to have_link 'ログアウト', href: destroy_admin_session_path
        end
      end

      context 'リンクの確認' do
        it 'トップページに遷移する' do
          click_on 'MemoBuilder'
          expect(current_path).to eq '/'
        end
        it '管理者TOPに遷移する' do
          click_on '管理者TOP'
          expect(current_path).to eq '/admins'
        end
        it 'ユーザ一覧に遷移する' do
          click_on 'ユーザ一覧'
          expect(current_path).to eq '/admins/users'
        end
        it '投稿一覧に遷移する' do
          click_on '投稿一覧'
          expect(current_path).to eq '/admins/memos'
        end
        it 'ログアウトする' do
          click_on 'ログアウト'
          expect(current_path).to eq '/admins/sign_in'
        end
      end
    end
  end
end
