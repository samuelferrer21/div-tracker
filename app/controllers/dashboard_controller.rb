class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?
    puts "Session #{user_signed_in?}"
    @test = Portfolio.where(user_id: current_user.id)

    # This will contain the stock data for the selected portfolio.
    @selectedPortfolio = nil

    if !params[:portfolio_id].nil?
      @selectedPortfolio = Portfolio_stock.where(portfolio_id: params[:portfolio_id]).all
    end

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
