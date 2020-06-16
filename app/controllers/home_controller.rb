class HomeController < ApplicationController
  def top
  	@user = User.new
  	@resent_memos = Memo.all.includes(:user).first(10)
  end

  def about
  end
end
