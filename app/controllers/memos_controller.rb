class MemosController < ApplicationController
  def all
		@q = Memo.ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def index
		@user = User.find(params[:user_id])
		@q = @user.memos.ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def new
  	@user = current_user
  	@houses = @user.houses.all.order(updated_at: :desc)
  	@rooms = @user.rooms.all.order(updated_at: :desc)
  	@memo = Memo.new
  end

  def create
  	@memo = current_user.memos.new(memo_params)
  	decide_parent(@memo)
  	@user = current_user
  	@houses = @user.houses.all.order(updated_at: :desc)
		@rooms = @user.rooms.all.order(updated_at: :desc)
  	if @memo.save
  		flash[:success]="投稿が完了しました"
  		back_in_place(@memo)
  	else
  		render :new
  	end
  end

  def show
  	@memo = Memo.find(params[:id])
  end

  def edit
  	@memo = Memo.find(params[:id])
  end

  def update
  	@memo = Memo.find(params[:id])
  	if @memo.update(memo_params)
  		flash[:success]="投稿を更新しました"
  		back_in_place(@memo)
  	else
  		render :edit
  	end
  end

  def destroy
  	@memo = Memo.find(params[:id])
  	@memo.destroy
  	flash[:alert]="投稿を削除しました"
  	back_in_place(@memo)
  end


  private
  def memo_params
  	params.require(:memo).permit(:title,:body,:tags_list,:range,:image,:house_id,:room_id)
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
