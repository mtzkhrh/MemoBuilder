class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @q = @user.memos.tag_counts.ransack(params[:q])
    @tags = @q.result(distinct: true)
  end

  def show
    @user = User.find(params[:user_id])
    @tag = Memo.tag_counts.find(params[:id])
    @q = Memo.tagged_with(@tag.name).where(user_id: @user.id).preload(:tags).ransack(params[:q])
    @memos = @q.result(distinct: true).page(params[:page])
  end
end
