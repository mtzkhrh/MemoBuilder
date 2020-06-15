class Admins::HomeController < ApplicationController
	before_action :authenticate_admin!

  def top
  	@users = User.all.order(created_at: :desc).first(10)
  	@memos = Memo.includes(:user).all.order(updated_at: :desc).first(10)
  end
end
