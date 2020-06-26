class UsersController < ApplicationController
  include MemosHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
    @user = current_user
  end

  def show
    @tags = @user.memos.tag_counts.order(updated_at: :desc).first(10)
    @houses = @user.houses.eager_load(:house_memos, :memos, :rooms).first(8)
    pickup_memos_within_range(@user, @user)
    @resent_memos = @memos.first(10)
  end

  def edit
    check_your_id(@user.id)
  end

  def update
    @user.assign_attributes(user_params)
    @user.profile_image_id = nil if params[:image_is_delete] == "true"
    if @user.save
      flash[:success] = "登録情報を更新しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:alert] = "登録情報を全て削除しました"
    redirect_to root_path
  end

  def stocks
    @user = User.find(params[:id])
    check_your_id(@user.id)
    @q = current_user.stock_memos.eager_load(:user).preload(:likes, :comments).resent.ransack(params[:q])
    @stocks = @q.result(distinct: true).page(params[:page])
  end

  def relationships
    @user = User.find(params[:id])
    check_your_id(@user.id)
    @q = @user.friends.ransack(params[:q])
    @friends = @q.result(distinct: true).page(params[:page])
    @r = @user.followings.where.not(id: @user.friends.pluck(:id)).ransack(params[:q])
    @followings = @r.result(distinct: true).page(params[:page])
    @s = @user.followers.where.not(id: @user.friends.pluck(:id)).ransack(params[:q])
    @followers = @s.result(distinct: true).page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :image_is_delete)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
