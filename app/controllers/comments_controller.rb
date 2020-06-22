class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    @memo = Memo.find(params[:memo_id])
    @comments = @memo.comments.all.eager_load(:user)
    @comment.save
  end

  def destroy
    comment = Comment.find(params[:id])
    check_your_id(comment.user_id)
    @memo = Memo.find(comment.memo_id)
    @comments = @memo.comments.all.eager_load(:user)
    comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:memo_id, :comment)
  end
end
