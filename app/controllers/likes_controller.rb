class LikesController < ApplicationController
  before_action :authenticate_user!

def create
	current_user.likes.create(memo_id: params[:memo_id])
	redirect_back(fallback_location: root_path)
end

def destroy
	current_user.likes.find_by(memo_id: params[:memo_id]).destroy
	redirect_back(fallback_location: root_path)
end

end
