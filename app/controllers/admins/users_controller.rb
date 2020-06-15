class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

  def index
  	@q = User.ransack(params[:q])
  	@users = @q.result(distinct: true)
  end

  def show
  	@user = User.find(params[:id])
    @q = @user.memos.ransack(params[:q])
    @memos = @q.result(distinct: true)
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success]="会員情報を更新しました"
      redirect_to admins_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:alert]="#{@user.name}を削除しました"
    redirect_to admins_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end


end
