class Admins::HomeController < ApplicationController
  before_action :authenticate_admin!

  def top
    @users = User.order(created_at: :desc).first(10)
    @memos = Memo.with_user.resent.first(10)
  end
end
