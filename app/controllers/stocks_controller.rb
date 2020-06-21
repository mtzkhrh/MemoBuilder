class StocksController < ApplicationController
  before_action :authenticate_user!

  def create
    @memo = Memo.find(params[:memo_id])
		current_user.stocks.create(memo_id: @memo.id)
  end

  def destroy
    @memo = Memo.find(params[:memo_id])
  	@stock = current_user.stocks.find_by(memo_id: @memo.id)
		@stock.destroy
  end

end