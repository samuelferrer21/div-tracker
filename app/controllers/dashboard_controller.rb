class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?
    puts "Session #{user_signed_in?}"
    @test = Portfolio.where(user_id: current_user.id)

  end



  def add_stock
    @UserIsSignedIn= user_signed_in?
    puts "added stock"

    #Insert new stock
  end

  def create
    #Creates a new portfolio of the user if it does not exist
    if Portfolio.where(user_id: current_user.id, portfolio_name: params[:portfolio_name]).empty?
      new_portfolio = Portfolio.new(portfolio_name: params[:portfolio_name], user_id: current_user.id)
      new_portfolio.save

      update_portfolio

    else
      flash[:alert] = "Portfolio already exists"
      redirect_back(fallback_location: dashboard_path)
    end


  end

  def update_portfolio
    puts "Updating portfolio"
    respond_to do |format|
      format.turbo_stream { render "dashboard/update_target", locals: { portfolio: Portfolio.where(user_id: current_user.id) }}
    end
  end
end
