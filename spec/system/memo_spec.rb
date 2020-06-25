require 'rails_helper'
RSpec.describe 'Memo', type: :system do
	describe 'メモのテスト' do
	  let!(:user) { create(:user) }
	  let!(:test_user2) { create(:user) }
	  let!(:house) { create(:house, user_id: user.id)}
	  let!(:room) { create(:room, user_id: user.id, house_id: house.id)}
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
	  		let(:test_house) {build(:house, user_id: user.id)}
	  		let(:test_room) {build(:room, user_id: user.id)}
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
	  	let(:memo){build(:memo,room_id: room.id, user_id: user.id)}
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
	  		it '家のセレクトボックスがある' do
	  			expect(page).to have_select 'memo[house_id]'
	  		end
	  		it '部屋のセレクトボックスがある',js: true do
	  			expect(page).to have_select 'memo[room_id]'
	  		end
	  		it '公開範囲のセレクトボックスがある' do
	  			expect(page).to have_select 'memo[range]'
	  		end
	  		it 'タイトルフォームがある' do
	  			expect(page).to have_field 'memo[title]'
	  		end
	  		it '本文フォームがある' do
	  			expect(page).to have_field 'memo[body]'
	  		end
	  		it '画像登録フォームがある' do
	  			expect(page).to have_field 'memo[image]'
	  		end
	  		it 'タグ付けフォームがある' do
	  			expect(page).to have_field 'memo[tag_list]'
	  		end
	  		it '投稿ボタンがある' do
	  			expect(page).to have_button '投稿'
	  		end
	  		it 'マイページへのリンクがある' do
	  			expect(page).to have_link '<< マイページへ', href: user_path(user)
	  		end
	  	end
	  	context 'jsの確認',js: true do
			  let!(:test_house2) { create(:house, user_id: user.id)}
			  let!(:test_house3) { create(:house, user_id: user.id)}
			  let!(:test_room2) { create(:room, user_id: user.id, house_id: test_house2.id)}
			  let!(:test_room3) { create(:room, user_id: user.id, house_id: test_house3.id)}
			  before do
			  	visit current_path
			  end
			  it '家を選択すると対応した部屋のセレクトボックスになる', js: true do
	  			select test_house2.name, from: 'memo[house_id]'
	  			expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください',test_room2.name])
	  			select test_house3.name, from: 'memo[house_id]'
	  			expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください',test_room3.name])
			  end
			  it '部屋を選択すると家のセレクトボックスの値も変わる' do
	  			select test_room2.name, from: 'memo[room_id]'
	  			expect(page).to have_select('memo[house_id]', selected: test_house2.name)
	  			visit current_path
	  			select test_room3.name, from: 'memo[room_id]'
	  			expect(page).to have_select('memo[house_id]', selected: test_house3.name)
			  end
	  	end
	  	context 'フォームの確認',js: true do
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

	  describe 'メモ編集画面のテスト' do
		  let(:test_house2) { create(:house, user_id: user.id)}
		  let(:test_house3) { create(:house, user_id: user.id)}
		  let!(:test_room2) { create(:room, user_id: user.id, house_id: test_house2.id)}
		  let!(:test_room3) { create(:room, user_id: user.id, house_id: test_house3.id)}
	  	let!(:memo){create(:memo,room_id: room.id, user_id: user.id)}
	  	before do
	  		visit edit_memo_path(memo)
	  	end
      context '自分のメモの編集画面への遷移' do
        it '遷移できる' do
          expect(current_path).to eq('/memos/' + memo.id.to_s + '/edit')
        end
      end
      context '他人のメモの編集画面への遷移' do
			  let(:test_user_house) { create(:house, user_id: test_user2.id)}
			  let(:test_user_room) { create(:room, user_id: test_user2.id, house_id: test_user_house.id)}
      	let!(:test_memo2){create(:memo, user_id: test_user2.id, room_id: test_user_room.id)}
        it '遷移できない' do
          visit edit_memo_path(test_memo2)
          expect(current_path).not_to eq('/memos/' + test_memo2.id.to_s + '/edit')
        end
      end
	  	context '表示の確認' do
	  		it '「メモの編集」が表示される' do
	  			expect(page).to have_content 'メモの編集'
	  		end
	  		it '家のセレクトボックスが選択されている',js: true do
	  			expect(page).to have_select('memo[house_id]', selected: house.name)
	  		end
	  		it '部屋のセレクトボックスが選択されている',js: true do
	  			expect(page).to have_select('memo[room_id]', selected: room.name)
	  		end
	  		it '公開範囲のセレクトボックスが選択されている' do
	  			expect(page).to have_select('memo[range]', selected: memo.range)
	  		end
	  		it 'タイトルフォームにタイトルが表示されている' do
	  			expect(page).to have_field 'memo[title]', with: memo.title
	  		end
	  		it '本文フォームに本文が表示されている' do
	  			expect(page).to have_field 'memo[body]', with: memo.body
	  		end
	  		it '画像登録フォームがある' do
	  			expect(page).to have_field 'memo[image]'
	  		end
	  		it 'タグ付けフォームにタグが表示されている' do
	  			expect(page).to have_field 'memo[tag_list]',with: memo.tag_list.join(",")
	  		end
	  		it '更新ボタンがある' do
	  			expect(page).to have_button '更新'
	  		end
	  		it '戻るリンクがある' do
	  			expect(page).to have_link '<< 戻る', href: memo_path(memo)
	  		end
	  	end
	  	context 'jsの確認',js: true do
			  it '家を選択すると対応した部屋のセレクトボックスになる', js: true do
	  			select test_house2.name, from: 'memo[house_id]'
	  			expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください',test_room2.name])
	  			select test_house3.name, from: 'memo[house_id]'
	  			expect(page).to have_select('memo[room_id]', options: ['部屋を選んでください',test_room3.name])
			  end
			  it '部屋を選択すると家のセレクトボックスの値も変わる' do
	  			select test_room2.name, from: 'memo[room_id]'
	  			expect(page).to have_select('memo[house_id]', selected: test_house2.name)
	  			visit current_path
	  			select test_room3.name, from: 'memo[room_id]'
	  			expect(page).to have_select('memo[house_id]', selected: test_house3.name)
			  end
	  	end
	  	context 'フォームの確認',js: true do
	  		let(:test_memo){ build(:memo,user_id: user.id, room_id: test_room2.id) }
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
	  			expect(@memo.room.name).not_to eq(test_room2.name)
	  			expect(@memo.room.house.name).not_to eq(test_house2.name)
	  			expect(@memo.range).not_to eq('公開')
	  		end
	  	end
	  end
	end
end