class HousesController < ApplicationController
  def index
  	@q = House.ransack(params[:q])
  	@houses = @q.result(distinct: true)
    @user = User.find(params[:user_id])
  end

  def create
  	@house = current_user.houses.new(house_params)
  	if @house.save
  		flash[:success]= "新しく家を建てました"
			redirect_back(fallback_location: root_path)
		else
	  	@q = House.ransack(params[:q])
	  	@houses = @q.result(distinct: true)
  	  @user = current_user
  	  flash[:alert]= "家を建てられませんでした"
  	  render :index
		end
  end

  def show
  	@house = House.find(params[:id])
  	@user = @house.user
  	@r = @house.rooms.ransack(params[:q])
  	@rooms = @r.result(distinct: true)
  	@q = @house.house_memos.ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def edit
  	@house = House.find(params[:id])
  	@rooms = @house.rooms.all
  	@memos = @house.house_memos.all
  end

  def update
  	@house = House.find(params[:id])
  	if @house.update(house_params)
  		flash[:success]= "家の名前を変更しました"
  		redirect_to user_houses_path(current_user)
  	else
  		render :edit
  	end
  end

  def destroy
  	house = House.find(params[:id])
  	house.destroy
  	flash[:alert]="家を取り壊しました"
		redirect_to user_houses_path(current_user)
	end



  private
  def house_params
	  params.require(:house).permit(:name)
  end
end
