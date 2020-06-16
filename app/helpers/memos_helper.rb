module MemosHelper

	# 自分とuserの関係を元にmemosを持ってくる
  def pickup_memos_within_range(parent,user)
  	# userのmemosを得る時
		if parent.name == "User"
			if user.id == current_user.id #自分の場合
				@memos = user.memos.all
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@memos = user.memos.only_friends.all
			else #他人の場合
				@memos = user.memos.open.all
			end
		# 家のmemosを得る場合
		elsif parent.name == "House"
			if user.id == current_user.id #自分の場合
				@memos = parent.house_memos.all
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@memos = parent.house_memos.only_friends.all
			else #他人の場合
				@memos = parent.house_memos.open.all
			end
		# 部屋のmemosを得る場合
		elsif parent.name == "Room"
			if user.id == current_user.id #自分の場合
				@memos = parent.memos.all
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@memos = parent.memos.only_friends.all
			else #他人の場合
				@memos = parent.memos.open.all
			end
		end
	end

end
