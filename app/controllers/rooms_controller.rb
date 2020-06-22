class RoomsController < ApplicationController
  include MemosHelper
  before_action :authenticate_user!
  before_action :set_room, only: [:show,:edit,:update,:destroy]

	def create
		@room = current_user.rooms.new(room_params)
		if @room.save
			@room.house.touch
			flash[:success]="部屋を作成しました"
			redirect_back(fallback_location: root_path)
		else
      flash[:alert]="部屋を作成できませんでした"
      redirect_back(fallback_location: root_path)
		end
	end

  def show
  	@user = @room.user
    pickup_memos_within_range(@room,@user)
  end

  def edit
    check_your_id(@room.user_id)
  	@user = @room.user
  	@memos = @room.memos.all
  end

  def update
    check_your_id(@room.user_id)
  	if @room.update(room_params)
  		House.find_by(id: room_params[:house_id]).touch	#移動先の家の更新日を変更する
  		flash[:success]="部屋を改装しました"
  		redirect_to house_path(@room.house)
  	else
      flash[:alert]= "部屋を改装できませんでした"
      redirect_back(fallback_location: root_path)
  	end
  end

  def destroy
    check_your_id(@room.user_id)
  	@room.destroy
  	flash[:alert]="部屋を取り壊しました"
  	redirect_to house_path(@room.house)
  end


  private
  def room_params
  	params.require(:room).permit(:name, :house_id)
  end
  def set_room
    @room = Room.find(params[:id])
  end




end
