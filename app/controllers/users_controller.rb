class UsersController < ApplicationController
  def index
  	@q = User.ransack(params[:q])
  	@users = @q.result(distinct: true)
    @user = current_user
  end

  def show
  	@user = User.find(params[:id])
    @tags = @user.memos.tag_counts.order(updated_at: :desc).first(5)
  	@houses = House.includes(:user).where(user_id: @user.id).order(updated_at: :desc).first(5)
  	@resent_memos = Memo.includes(:user).where(user_id: @user.id).order(updated_at: :desc).first(6)
  end

  def relationships
    @user = User.find(params[:id])
    @q = @user.friends.ransack(params[:q])
    @friends = @q.result(distinct: true)
    @followings = @user.followings.where.not(id: @friends.pluck(:id))
    @followers = @user.followers.where.not(id: @friends.pluck(:id))
  end

  def stocks
    @user = current_user
    @q = current_user.stock_memos.ransack(params[:q])
    @stocks = @q.result(distinct: true)
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success]= "登録情報を更新しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:alert]="登録情報を全て削除しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end




end
