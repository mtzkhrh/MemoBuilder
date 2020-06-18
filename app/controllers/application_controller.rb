class ApplicationController < ActionController::Base

	protected
	def check_your_id(user_id)
		redirect_back(fallback_location: root_path) unless user_id == current_user.id
	end
end
