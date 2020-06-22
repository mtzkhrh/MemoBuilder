class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @memo = Memo.find(params[:memo_id])
    current_user.likes.create(memo_id: @memo.id)
  end

  def destroy
    @memo = Memo.find(params[:memo_id])
    current_user.likes.find_by(memo_id: @memo.id).destroy
  end
end
