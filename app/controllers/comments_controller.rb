class CommentsController < ApplicationController

	def create
		@comment = current_user.comments.new(comment_params)
		if @comment.save
			flash[:success]="コメントを送信しました"
			redirect_back(fallback_location: root_path)
		else
			@memo = Memo.find(params[:id])
		  @comments = @memo.comments.all.includes(:user)
			render 'memos/show'
		end
	end

	def destroy
		redirect_back(fallback_location: root_path)
	end

	private
	def comment_params
		params.require(:comment).permit(:memo_id,:comment)
	end
end
