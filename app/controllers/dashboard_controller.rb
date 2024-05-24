class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?
    puts "Session #{user_signed_in?}"
  end

  def add_stock
    @UserIsSignedIn= user_signed_in?
    puts "added stock"

    #Insert new stock
  end
end
