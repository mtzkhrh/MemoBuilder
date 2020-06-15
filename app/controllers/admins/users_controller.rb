class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!
  before_action :set_user, only: [:show,:edit,:update,:destroy]


  def index
  	@q = User.ransack(params[:q])
  	@users = @q.result(distinct: true)
  end

  def show
    @q = @user.memos.ransack(params[:q])
    @memos = @q.result(distinct: true)
  end

  def edit
  end

  def update
    @user.profile_image_id = nil if params[:user][:profile_image_delete] == "true"
    if @user.update(user_params)
      flash[:success]="管理者権限で会員情報を更新しました"
      redirect_to admins_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:alert]="#{@user.name}を削除しました"
    redirect_to admins_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
