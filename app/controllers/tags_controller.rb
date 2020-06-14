class TagsController < ApplicationController
  def index
  	@user = User.find(params[:user_id])
    @q = @user.memos.tag_counts.ransack(params[:q])
    @tags = @q.result(distinct: true)
  end

  def show
  	@user = User.find(params[:user_id])
  	@tag = Memo.tag_counts.find(params[:id])
  	@memos = Memo.tagged_with(@tag.name).where(user_id: @user.id)
  end
end
