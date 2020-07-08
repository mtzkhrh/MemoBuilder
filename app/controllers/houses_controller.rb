class HousesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_house, only: [:show, :edit, :update, :destroy]

  def index
    @user = User.find(params[:user_id])
    @q = @user.houses.resent.ransack(params[:q])
    @houses = @q.result(distinct: true).page(params[:page])
  end

  def create
    @user = User.find(params[:user_id])
    check_your_id(@user.id)
    @house = @user.houses.new(house_params)
    if @house.save
      flash[:success] = "新しく家を建てました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "家を建てられませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @user = @house.user
    @r = @house.rooms.resent.ransack(params[:q])
    @rooms = @r.result(distinct: true).page(params[:page])
    pickup_memos_within_range(@house, @user)
  end

  def edit
    check_your_id(@house.user_id)
    @rooms = @house.rooms.all
    @memos = @house.house_memos.all
  end

  def update
    check_your_id(@house.user_id)
    if @house.update(house_params)
      flash[:success] = "家の名前を変更しました"
      redirect_to user_houses_path(current_user)
    else
      flash[:alert] = "家の名前を変更できませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    check_your_id(@house.user_id)
    @house.destroy
    flash[:alert] = "家を取り壊しました"
    redirect_to user_houses_path(current_user)
  end

  private

  def house_params
    params.require(:house).permit(:name)
  end

  def set_house
    @house = House.find(params[:id])
  end
end
