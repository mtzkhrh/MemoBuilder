class Admins::MemosController < ApplicationController
	before_action :authenticate_admin!

  def index
  	@q = Memo.ransack(params[:q])
  	@memos = @q.result(distinct: true)
  end

  def show
  	@memo = Memo.find(params[:id])
  end

  def edit
  	@memo = Memo.find(params[:id])
  end
end
