class UsersController < ApplicationController
  include MemosHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show,:edit,:update,:destroy]

  def index
  	@q = User.ransack(params[:q])
  	@users = @q.result(distinct: true)
    @user = current_user
  end

  def show
    @tags = @user.memos.tag_counts.order(updated_at: :desc).first(10)
  	@houses = @user.houses.eager_load(:house_memos,:memos,:rooms).first(5)
  	pickup_memos_within_range(@user,@user)
    @resent_memos = @memos.first(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success]= "登録情報を更新しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:alert]="登録情報を全て削除しました"
    redirect_to root_path
  end

  def stocks
    @user = current_user
    @q = current_user.stock_memos.resent.ransack(params[:q])
    @stocks = @q.result(distinct: true)
  end

  def relationships
    @user = User.eager_load(:followings).find(params[:id])
    @q = @user.friends.ransack(params[:q])
    @friends = @q.result(distinct: true)
    @r = @user.followings.where.not(id: @user.friends.pluck(:id)).ransack(params[:q])
    @followings = @r.result(distinct: true)
    @s = @user.followers.where.not(id: @user.friends.pluck(:id)).ransack(params[:q])
    @followers = @s.result(distinct: true)
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end




end
