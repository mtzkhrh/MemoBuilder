class HomeController < ApplicationController
  def top
    @user = User.new
    @memos = Memo.open.resent.eager_load(:user).preload(:likes, :comments).first(20)
  end

  def about
  end
end
