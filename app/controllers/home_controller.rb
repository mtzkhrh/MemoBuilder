class HomeController < ApplicationController
  def top
  	@user = User.new
  	@resent_memos = Memo.all.eager_load(:user).first(10)
  end

  def about
  end
end
