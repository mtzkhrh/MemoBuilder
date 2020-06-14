class StocksController < ApplicationController

  def create
  	# urlで(memo_id: @memo.id)を記述してparamsを渡す
		current_user.stocks.create(memo_id: params[:memo_id])
		redirect_back(fallback_location: root_path)
  end

  def destroy
  	@stock = current_user.stocks.find_by(memo_id: params[:memo_id])
  	if @stock.user_id == current_user.id
  		@stock.destroy
			redirect_back(fallback_location: root_path)
		else
			redirect_back(fallback_location: root_path)
		end
  end

end