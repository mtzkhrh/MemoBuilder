class TagsController < ApplicationController
  def index
  	@user = User.find(params[:user_id])
  	@tags = []
  	@memos = @user.memos.all
  	@memos.each do |memo|
  		@tags += memo.tags
  	end
  end

  def show
  	@user = User.find(params[:user_id])
  	@tag = Memo.tag_counts.find(params[:id])
  	@memos = Memo.tagged_with(@tag.name).where(user_id: @user.id)
  end
end
