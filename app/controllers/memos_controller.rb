class MemosController < ApplicationController
  include MemosHelper
  before_action :authenticate_user!
  before_action :set_memo, only: [:show,:edit,:update,:destroy]

  def all
		@q = Memo.open.ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def index
		@user = User.find(params[:user_id])
    pickup_memos_within_range(@user,@user)
  end

  def new
  	@user = current_user
  	@houses = @user.houses.all.resent
  	@rooms = @user.rooms.all.resent
  	@memo = Memo.new

  end

  def create
  	@memo = current_user.memos.new(memo_params)
  	decide_parent(@memo)
  	@user = current_user
  	@houses = @user.houses.all.resent
		@rooms = @user.rooms.all.resent
  	if @memo.save
  		flash[:success]="投稿が完了しました"
  		back_in_place(@memo)
  	else
  		render :new
  	end
  end

  def show
    range_barrier(@memo)
    @tags = @memo.tags
    @comments = @memo.comments.all.includes(:user)
    @comment = Comment.new
  end

  def edit
    check_your_id(@memo.user_id)
  	@houses = @user.houses.all.resent
  	@rooms = @user.rooms.all.resent
  end

  def update
    check_your_id(@memo.user_id)
    @memo.tag_list.remove(@memo.tag_list)
  	@memo.assign_attributes(memo_params)
  	decide_parent(@memo)
  	if @memo.save
  		flash[:success]="投稿を更新しました"
  		back_in_place(@memo)
  	else
  		render :edit
  	end
  end

  def destroy
    check_your_id(@memo.user_id)
  	@memo.destroy
  	flash[:alert]="投稿を削除しました"
  	back_in_place(@memo)
  end


  private
  def memo_params
  	params.require(:memo).permit(:title,:body,:tag_list,:range,:image,:house_id,:room_id)
  end
  def set_memo
    @memo = Memo.find(params[:id])
  end

  def range_barrier(memo)
    if memo.range == "自分のみ" #自分以外back
      back(fallback_location: root_path) unless memo.user_id == current_user.id
    elsif memo.range == "友達のみ" #自分と友達以外back
      back(fallback_location: root_path) unless memo.user_id == current_user.id || current_user.friends.id.include?(memo.user_id)
    end
  end

  def back_in_place(memo)
  	if memo.house_id.blank?
			redirect_to room_path(memo.room)
		else #@memo.house == true
			redirect_to house_path(memo.house)
		end
	end
	def decide_parent(memo)
  	if @memo.house_id && @memo.room_id
  		@memo.house_id = nil
  	end
	end

end
