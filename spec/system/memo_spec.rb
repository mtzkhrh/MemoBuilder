require 'rails_helper'
RSpec.describe 'Memo', type: :system do
  describe 'メモのテスト' do
    let!(:user) { create(:user) }
    let!(:test_user2) { create(:user) }
    let!(:house) { create(:house, user_id: user.id) }
    let!(:room) { create(:room, user_id: user.id, house_id: house.id) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe 'サイドバーのテスト' do
      before do
        visit new_user_memo_path(user)
      end

      context '表示の確認' do
        it '家の作成フォームが表示される' do
          expect(page).to have_field 'house[name]'
        end
        it '家のセレクトボックスを含む部屋の作成フォームがある' do
          expect(page).to have_select 'room[house_id]'
          expect(page).to have_field 'room[name]'
        end
      end

      context 'フォームの確認' do
        let(:test_house) { build(:house, user_id: user.id) }
        let(:test_room) { build(:room, user_id: user.id) }

        it '家の作成に成功する' do
          fill_in 'house[name]', with: test_house.name
          click_button 'house[submit]'
          expect(user.houses.size).to eq(2)
        end
        it '家の作成に失敗する' do
          fill_in 'house[name]', with: ""
          click_button 'house[submit]'
          expect(user.houses.size).to eq(1)
        end
        it '部屋の作成に成功する' do
          select house.name, from: 'room[house_id]'
          fill_in 'room[name]', with: test_room.name
          click_button 'room[submit]'
          expect(user.rooms.size).to eq(2)
        end
        it '部屋の作成に失敗する' do
          select house.name, from: 'room[house_id]'
          fill_in 'room[name]', with: ""
          click_button 'room[submit]'
          expect(user.rooms.size).to eq(1)
          select "家を選んでください", from: 'room[house_id]'
          fill_in 'room[name]', with: test_room.name
          click_button 'room[submit]'
          expect(user.rooms.size).to eq(1)
        end
      end
    end

    describe '新規投稿画面のテスト' do
      let(:memo) { build(:memo, room_id: room.id, user_id: user.id) }

      before do
        visit new_user_memo_path(user)
      end

      context '自分の新規投稿画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/users/' + user.id.to_s + '/memos/new')
        end
      end

      context '他人の新規投稿画面への遷移' do
        it '遷移できない' do
          visit new_user_memo_path(test_user2)
          expect(current_path).not_to eq('/users/' + test_user2.id.to_s + '/memos/new')
        end
      end

      context '表示の確認' do
        it '「メモの作成」が表示される' do
          expect(page).to have_content 'メモの作成'
        end
        it '家のセレクトボックスが表示される' do
          expect(page).to have_select 'memo[house_id]'
        end
        it '部屋のセレクトボックスが表示される', js: true do
          expect(page).to have_select 'memo[room_id]'
        end
        it '公開範囲のセレクトボックスが表示される' do
          expect(page).to have_select 'memo[range]'
        end
        it 'タイトルフォームが表示される' do
          expect(page).to have_field 'memo[title]'
        end
        it '本文フォームが表示される' do
          expect(page).to have_field 'memo[body]'
        end
        it '画像登録フォームが表示される' do
          expect(page).to have_field 'memo[image]'
        end
        it 'タグ付けフォームが表示される' do
          expect(page).to have_field 'memo[tag_list]'
        end
        it '投稿ボタンが表示される' do
          expect(page).to have_button '投稿'
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end

      context 'jsの確認', js: true do
        let!(:test_house2) { create(:house, user_id: user.id) }
        let!(:test_house3) { create(:house, user_id: user.id) }
        let!(:test_room2) { create(:room, user_id: user.id, house_id: test_house2.id) }
        let!(:test_room3) { create(:room, user_id: user.id, house_id: test_house3.id) }

        before do
          visit current_path
        end

        it '家を選択すると対応した部屋のセレクトボックスになる', js: true do
          select test_house2.name, from: 'memo[house_id]'
          expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください', test_room2.name])
          select test_house3.name, from: 'memo[house_id]'
          expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください', test_room3.name])
        end
        it '部屋を選択すると家のセレクトボックスの値も変わる' do
          select test_room2.name, from: 'memo[room_id]'
          expect(page).to have_select('memo[house_id]', selected: test_house2.name)
          visit current_path
          select test_room3.name, from: 'memo[room_id]'
          expect(page).to have_select('memo[house_id]', selected: test_house3.name)
        end
      end

      context 'フォームの確認', js: true do
        it 'メモの投稿に成功する' do
          sleep 0.5
          select house.name, from: 'memo[house_id]'
          select room.name, from: 'memo[room_id]'
          select '自分のみ', from: 'memo[range]'
          fill_in 'memo[title]', with: memo.title
          fill_in_ckeditor :memo_body, with: memo.body
          fill_in 'memo[tag_list]', with: memo.tag_list.join(",")
          click_button '投稿'
          expect(page).to have_content '投稿が完了しました'
          expect(user.memos.size).to eq(1)
        end
        it 'メモの投稿に失敗する' do
          select house.name, from: 'memo[house_id]'
          select room.name, from: 'memo[room_id]'
          select '自分のみ', from: 'memo[range]'
          fill_in 'memo[title]', with: ""
          fill_in_ckeditor :memo_body, with: ""
          fill_in 'memo[tag_list]', with: memo.tag_list.join(",")
          click_button '投稿'
          expect(page).to have_content 'エラー'
          expect(user.memos.size).to eq(0)
        end
      end
    end

    describe 'メモの詳細画面のテスト' do
      let!(:memo) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:comment) { create(:comment, user_id: user.id, memo_id: memo.id) }
      let!(:test_comment2) { create(:comment, user_id: test_user2.id, memo_id: memo.id) }
      # 公開と自分のみの投稿ユーザ
      let(:close_user) { create(:user) }
      let(:close_user_house) { create(:house, user_id: close_user.id) }
      let(:close_user_room) { create(:room, user_id: close_user.id, house_id: close_user_house.id) }
      let!(:close_memo) { create(:memo, room_id: close_user_room.id, user_id: close_user.id, range: '自分のみ') }
      let!(:open_memo) { create(:memo, room_id: close_user_room.id, user_id: close_user.id, range: '公開') }
      # 友達のみの投稿ユーザ
      let(:friend_user) { create(:user) }
      let(:friend_user_house) { create(:house, user_id: friend_user.id) }
      let(:friend_user_room) { create(:room, user_id: friend_user.id, house_id: friend_user_house.id) }
      let!(:friend_memo) { create(:memo, room_id: friend_user_room.id, user_id: friend_user.id, range: '友達のみ') }

      before do
        user.follow(friend_user.id)
        friend_user.follow(user.id)
        visit memo_path(memo)
      end

      context '自分のメモの詳細画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/memos/' + memo.id.to_s)
          memo.range = '友達のみ'
          visit memo_path(memo)
          expect(current_path).to eq('/memos/' + memo.id.to_s)
          memo.range = '公開'
          visit memo_path(memo)
          expect(current_path).to eq('/memos/' + memo.id.to_s)
        end
      end

      context '他人の公開されたメモの詳細画面への遷移' do
        it '遷移できる' do
          visit memo_path(open_memo)
          expect(current_path).to eq('/memos/' + open_memo.id.to_s)
        end
      end

      context '他人の友達のみ公開のメモの詳細画面への遷移' do
        it '友達は遷移できる' do
          visit memo_path(friend_memo)
          expect(current_path).to eq('/memos/' + friend_memo.id.to_s)
        end
        it '友達以外は遷移できない' do
          user.unfollow(friend_user.id)
          visit memo_path(friend_memo)
          expect(current_path).not_to eq('/memos/' + friend_memo.id.to_s)
        end
      end

      context '他人の非公開メモの詳細画面への遷移' do
        it '遷移できない' do
          visit memo_path(close_memo)
          expect(current_path).not_to eq('/memos/' + close_memo.id.to_s)
        end
      end

      context '表示の確認' do
        it 'パンくずリストが表示される' do
          expect(find('.breadcrumb')).to have_content(user.name + " " + memo.room.house.name + " " + memo.room.name + " " + memo.title)
        end
        it 'タイトルが表示される' do
          expect(page).to have_selector 'div.memos_title', text: memo.title
        end
        it '公開範囲が表示される' do
          expect(page).to have_content memo.range
        end
        it 'タグのリンクが表示される' do
          expect(page).to have_link memo.tag_list[0]
          expect(page).to have_link memo.tag_list[1]
        end
        it '本文が表示される' do
          expect(page).to have_content memo.body
        end
        it 'いいねボタンが表示される' do
          expect(page).to have_link 'Like', href: memo_likes_path(memo)
        end
        it 'ストックボタンが表示される' do
          expect(page).to have_link 'ストックする', href: memo_stocks_path(memo)
        end
        it '自分の投稿には編集ボタンが表示される' do
          expect(page).to have_link '編集', href: edit_memo_path(memo)
          visit memo_path(open_memo)
          expect(page).not_to have_link '編集', href: edit_memo_path(open_memo)
        end
        it 'コメントが表示される' do
          expect(page).to have_content comment.comment
        end
        it '自分のコメントには削除ボタンが表示される' do
          expect(page).to have_link '削除', href: comment_path(comment)
        end
        it '他人のコメントには削除ボタンが表示されない' do
          expect(page).not_to have_link '削除', href: comment_path(test_comment2)
        end
        it 'コメントフォームが表示される' do
          expect(page).to have_field 'comment[comment]'
        end
        it '自分のアイコンがコメントフォーム下に表示される' do
          expect(page).to have_selector 'img.profile_image'
        end
        it 'コメントを送るボタンがある' do
          expect(page).to have_button 'コメント送信'
        end
        it '戻るリンクがある' do
          expect(page).to have_link '<< 戻る'
        end
      end

      context 'コメント削除のテスト', js: true do
        it '削除できる' do
          click_on '削除'
          sleep 0.5
          expect(page).not_to have_link '削除'
        end
      end

      context 'Likeボタンのテスト', js: true do
        it 'Likeする' do
          click_on "Like"
          sleep 0.5
          expect(user.likes.size).to eq(1)
          expect(find('#like_count')).to have_content '1'
        end
        it 'Likeを消す' do
          create(:like, user_id: user.id, memo_id: memo.id)
          visit current_path
          click_on "Like"
          sleep 0.5
          expect(user.likes.size).to eq(0)
          expect(find('#like_count')).to have_content '0'
        end
      end

      context 'ストックボタンのテスト', js: true do
        it 'ストックする' do
          click_on 'ストックする'
          sleep 0.5
          expect(page).to have_content 'ストック中'
          expect(user.stocks.size).to eq(1)
        end
        it 'ストックを消す' do
          create(:stock, user_id: user.id, memo_id: memo.id)
          visit current_path
          click_on 'ストック中'
          sleep 0.5
          expect(page).to have_content 'ストックする'
          expect(user.stocks.size).to eq(0)
        end
      end

      context 'コメントフォームの確認', js: true do
        let(:test_comment) { build(:comment, user_id: test_user2.id, memo_id: memo.id) }

        it 'コメントの送信に成功する' do
          fill_in 'comment[comment]', with: test_comment.comment
          click_on 'comment[submit]'
          sleep 0.5
          expect(page).to have_content test_comment.comment
          expect(memo.comments.size).to eq(3)
        end
        it 'コメントの送信に失敗する' do
          fill_in 'comment[comment]', with: ""
          click_on 'comment[submit]'
          sleep 0.5
          expect(page).to have_content 'コメントを入力してください'
          expect(memo.comments.size).to eq(2)
        end
      end
    end

    describe 'メモ編集画面のテスト' do
      let(:test_house2) { create(:house, user_id: user.id) }
      let(:test_house3) { create(:house, user_id: user.id) }
      let!(:test_room2) { create(:room, user_id: user.id, house_id: test_house2.id) }
      let!(:test_room3) { create(:room, user_id: user.id, house_id: test_house3.id) }
      let!(:memo) { create(:memo, room_id: room.id, user_id: user.id) }

      before do
        visit edit_memo_path(memo)
      end

      context '自分のメモの編集画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/memos/' + memo.id.to_s + '/edit')
        end
      end

      context '他人のメモの編集画面への遷移' do
        let(:test_user_house) { create(:house, user_id: test_user2.id) }
        let(:test_user_room) { create(:room, user_id: test_user2.id, house_id: test_user_house.id) }
        let!(:test_memo2) { create(:memo, user_id: test_user2.id, room_id: test_user_room.id) }

        it '遷移できない' do
          visit edit_memo_path(test_memo2)
          expect(current_path).not_to eq('/memos/' + test_memo2.id.to_s + '/edit')
        end
      end

      context '表示の確認' do
        it '「メモの編集」が表示される' do
          expect(page).to have_content 'メモの編集'
        end
        it '家のセレクトボックスが選択される', js: true do
          expect(page).to have_select('memo[house_id]', selected: house.name)
        end
        it '部屋のセレクトボックスが選択される', js: true do
          expect(page).to have_select('memo[room_id]', selected: room.name)
        end
        it '公開範囲のセレクトボックスが選択される' do
          expect(page).to have_select('memo[range]', selected: memo.range)
        end
        it 'タイトルフォームにタイトルが表示される' do
          expect(page).to have_field 'memo[title]', with: memo.title
        end
        it '本文フォームに本文が表示される' do
          expect(page).to have_field 'memo[body]', with: memo.body
        end
        it '画像登録フォームが表示される' do
          expect(page).to have_field 'memo[image]'
        end
        it 'タグ付けフォームにタグが表示される' do
          expect(page).to have_field 'memo[tag_list]', with: memo.tag_list.join(",")
        end
        it '更新ボタンが表示される' do
          expect(page).to have_button '更新'
        end
        it '戻るリンクが表示される' do
          expect(page).to have_link '<< 戻る', href: memo_path(memo)
        end
      end

      context 'jsの確認', js: true do
        it '家を選択すると対応した部屋のセレクトボックスになる', js: true do
          select test_house2.name, from: 'memo[house_id]'
          expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください', test_room2.name])
          select test_house3.name, from: 'memo[house_id]'
          expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください', test_room3.name])
        end
        it '部屋を選択すると家のセレクトボックスの値も変わる' do
          select test_room2.name, from: 'memo[room_id]'
          expect(page).to have_select('memo[house_id]', selected: test_house2.name)
          visit current_path
          select test_room3.name, from: 'memo[room_id]'
          expect(page).to have_select('memo[house_id]', selected: test_house3.name)
        end
      end

      context 'フォームの確認', js: true do
        let(:test_memo) { build(:memo, user_id: user.id, room_id: test_room2.id) }

        it 'メモの編集に成功する' do
          sleep 0.5
          select test_house2.name, from: 'memo[house_id]'
          select test_room2.name, from: 'memo[room_id]'
          select '公開', from: 'memo[range]'
          fill_in 'memo[title]', with: test_memo.title
          fill_in_ckeditor :memo_body, with: test_memo.body
          fill_in 'memo[tag_list]', with: test_memo.tag_list.join(",")
          click_button '更新'
          expect(page).to have_content '投稿を更新しました'
          @memo = Memo.find(memo.id)
          expect(@memo.room.name).to eq(test_room2.name)
          expect(@memo.room.house.name).to eq(test_house2.name)
          expect(@memo.range).to eq('公開')
        end
        it 'メモの編集に失敗する' do
          select test_house2.name, from: 'memo[house_id]'
          select test_room2.name, from: 'memo[room_id]'
          select '公開', from: 'memo[range]'
          fill_in 'memo[title]', with: ""
          fill_in_ckeditor :memo_body, with: ""
          fill_in 'memo[tag_list]', with: test_memo.tag_list.join(",")
          click_button '更新'
          expect(page).to have_content 'エラー'
          @memo = Memo.find(memo.id)
          expect(@memo.room.name).to eq(memo.room.name)
          expect(@memo.room.house.name).to eq(memo.room.house.name)
          expect(@memo.range).to eq('自分のみ')
        end
      end
    end

    describe 'メモ一覧画面のテスト' do
      let!(:memo1) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:memo2) { create(:memo, room_id: room.id, user_id: user.id, range: '公開') }
      let!(:close_memo) { create(:memo, room_id: room.id, user_id: test_user2.id) }

      before do
        visit user_memos_path(user)
      end

      context '表示の確認' do
        it '「投稿一覧」が表示される' do
          expect(page).to have_content '投稿一覧'
        end
        it 'メモのタイトルリンクが表示される' do
          expect(page).to have_link memo1.title, href: memo_path(memo1)
          expect(page).to have_link memo2.title, href: memo_path(memo2)
        end
        it 'メモのタグがリンクで表示される' do
          expect(page).to have_link memo1.tag_list[0]
          expect(page).to have_link memo1.tag_list[1]
          expect(page).to have_link memo1.tag_list[2]
          expect(page).to have_link memo2.tag_list[0]
          expect(page).to have_link memo2.tag_list[1]
          expect(page).to have_link memo2.tag_list[2]
        end
        it 'メモの公開範囲が表示される' do
          expect(page).to have_content memo1.range
          expect(page).to have_content memo2.range
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[title_cont]'
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
        it '非公開メモは他人に表示されない' do
          visit user_memos_path(test_user2)
          expect(current_path).to eq('/users/' + test_user2.id.to_s + '/memos')
          expect(page).not_to have_content close_memo.title
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
    end

    describe '公開投稿一覧画面のテスト' do
      let!(:close_memo) { create(:memo, room_id: room.id, user_id: user.id) }
      let!(:open_memo) { create(:memo, room_id: room.id, user_id: user.id, range: '公開') }
      let!(:like) { create(:like, user_id: user.id, memo_id: open_memo.id) }

      before do
        visit memos_all_path
      end

      context '表示の確認' do
        it '「公開された投稿一覧」が表示される' do
          expect(page).to have_content '公開された投稿一覧'
        end
        it '公開された投稿のタイトルリンクが表示される' do
          expect(page).to have_link open_memo.title, href: memo_path(open_memo)
        end
        it '公開されていない投稿は表示されない' do
          expect(page).not_to have_content close_memo.title
        end
        it '投稿したユーザリンクが表示される' do
          expect(find('.list_item')).to have_link user.name, href: user_path(user)
        end
        it '投稿のLikeの数が表示される' do
          expect(find('.list_item')).to have_content open_memo.likes.size
        end
        it '投稿のコメント数が表示される' do
          expect(find('.list_item')).to have_content open_memo.comments.size
        end
        it '検索フォームが表示される' do
          expect(page).to have_field 'q[title_cont]'
        end
        it 'マイページへのリンクが表示される' do
          expect(page).to have_link '<< マイページへ', href: user_path(user)
        end
      end

      context '検索フォームの確認' do
        let!(:memo1) { create(:memo, room_id: room.id, user_id: user.id, range: '公開') }
        let!(:memo2) { create(:memo, room_id: room.id, user_id: user.id, range: '公開') }

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
