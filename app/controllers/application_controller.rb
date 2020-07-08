class ApplicationController < ActionController::Base
  protected
	# 自分とuserの関係を元にmemosを持ってくる
  def pickup_memos_within_range(parent, user)
    # userのmemosを得る時
    if parent.class.name == "User"
    	pickup_memos_from_user(user)

    # 家のmemosを得る場合
    elsif parent.class.name == "House"
    	pickup_memos_from_house(parent, user)

    # 部屋のmemosを得る場合
    elsif parent.class.name == "Room"
    	pickup_memos_from_room(parent, user)
    end
  end

  def pickup_memos_from_user(user)
    if user.id == current_user.id #自分の場合
      @q = user.memos.resent.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    elsif user.friends.pluck(:id).include?(current_user.id) #友達の場合
      @q = user.memos.only_friends.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    else #他人の場合
      @q = user.memos.open.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    end
  end
  def pickup_memos_from_house(house, user)
    if user.id == current_user.id
      @q = house.house_memos.resent.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    elsif user.friends.pluck(:id).include?(current_user.id)
      @q = house.house_memos.only_friends.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    else
      @q = house.house_memos.open.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    end
  end
  def pickup_memos_from_room(room, user)
    if user.id == current_user.id
      @q = room.memos.resent.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    elsif user.friends.pluck(:id).include?(current_user.id)
      @q = room.memos.only_friends.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    else
      @q = room.memos.open.with_tags.ransack(params[:q])
      @memos = @q.result(distinct: true).page(params[:page])
    end
  end

  def check_your_id(user_id)
    redirect_back(fallback_location: root_path) unless user_id == current_user.id
  end
end
