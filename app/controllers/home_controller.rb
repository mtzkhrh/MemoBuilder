class HomeController < ApplicationController
  def top
    @user = User.new
    @memos = Memo.open.with_user.resent.first(20)
  end

  def about
  end
end
