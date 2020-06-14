class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

  def index
  end

  def show
  end

  def edit
  end
end
