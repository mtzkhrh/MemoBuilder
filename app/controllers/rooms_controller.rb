class RoomsController < ApplicationController

	def create
		@room = current_user.rooms.new(room_params)
		if @room.save
			flash[:success]="部屋を作成しました"
			redirect_back(fallback_location: root_path)
		else
			# ハウス内の一覧に戻る
			@house = House.find(room_params[:house_id])
	  	@user = @house.user
	  	@r = @house.rooms.ransack(params[:r])
	  	@rooms = @r.result(distinct: true)
	  	@q = @house.house_memos.ransack(params[:q])
	  	@memos = @q.result(distinct: true)
			render 'houses/show'
		end
	end

  def show
  	@room = Room.find(params[:id])
  	@q = @room.memos.ransack(params[:q])
  	@memos = @q.result(distinct: :ture)
  end

  def edit
  	@room = Room.find(params[:id])
  	@memos = @room.memos.all
  end

  def update
  	@room = Room.find(params[:id])
  	@room.house.touch	#家の更新日を変更する
  	if @room.update(room_params)
  		flash[:success]="部屋を作り替えました"
  		redirect_to house_path(@room.house)
  	else
  		render :edit
  	end
  end

  def destroy
  	@room = room.find(params[:id])
  	@room.destroy
  	flash[:alert]="部屋を取り壊しました"
  	redirect_to house_path(@room.house)
  end


  private
  def room_params
  	params.require(:room).permit(:name, :house_id)
  end




end
