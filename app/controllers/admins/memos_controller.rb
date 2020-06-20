class Admins::MemosController < ApplicationController
	before_action :authenticate_admin!
  before_action :set_memo, only: [:show,:edit,:update,:destroy]

  def index
  	@q = Memo.includes(:user).ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def show
  end

  def edit
  end

  def update
    @memo.image_id = nil if params[:memo][:image_delete] == "true"
    if @memo.update(memo_params)
      flash[:success]="管理者権限で投稿を編集しました"
      redirect_to admins_memo_path(@memo)
    else
      render :edit
    end
  end

  def destroy
    @memo.destroy
    flash[:alert]="#{@memo.user.name}の投稿(#{@memo.title})を削除しました"
    redirect_to admins_user_path(@memo.user_id)
  end

  private
  def memo_params
    params.require(:memo).permit(:title,:body,:range)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end

end
