module MemosHelper

	# 自分とuserの関係を元にmemosを持ってくる
  def pickup_memos_within_range(parent,user)
  	# userのmemosを得る時
		if parent.class.name == "User"
			if user.id == current_user.id #自分の場合
				@q = user.memos.resent.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@q = user.memos.only_friends.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			else #他人の場合
				@q = user.memos.open.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			end
		# 家のmemosを得る場合
		elsif parent.class.name == "House"
			if user.id == current_user.id #自分の場合
				@q = parent.house_memos.resent.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@q = parent.house_memos.only_friends.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			else #他人の場合
				@q = parent.house_memos.open.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			end
		# 部屋のmemosを得る場合
		elsif parent.class.name == "Room"
			if user.id == current_user.id #自分の場合
				@q = parent.memos.resent.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
				@q = parent.memos.only_friends.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			else #他人の場合
				@q = parent.memos.open.with_tags.ransack(params[:q])
				@memos = @q.result(distinct: true)
			end
		end
	end

end
