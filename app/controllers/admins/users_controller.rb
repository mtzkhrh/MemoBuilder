class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

  def index
  	@q = User.ransack(params[:q])
  	@users = @q.result(distinct: true)
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  	@user = User.find(params[:id])
  end
end
