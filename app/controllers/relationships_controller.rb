class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user.id)
    # もし相手が自分をフォローしてたらそれも削除する＝関係のリセット
    user.unfollow(current_user.id) if user.following?(current_user)
    redirect_back(fallback_location: root_path)
  end
end
