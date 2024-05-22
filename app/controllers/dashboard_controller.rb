class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?
    puts "Session #{user_signed_in?}"

  end
end
