class Admins::HomeController < ApplicationController
	before_action :authenticate_admin!

  def top
  	@users = User.preload(:memos).order(created_at: :desc).first(10)
  	@memos = Memo.eager_load(:user).preload(:comments, :likes).resent.first(10)
  end
end
