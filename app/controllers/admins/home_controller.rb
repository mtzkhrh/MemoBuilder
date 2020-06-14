class Admins::HomeController < ApplicationController
	before_action :authenticate_admin!

  def top
  end
end
