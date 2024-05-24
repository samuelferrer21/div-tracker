class PortfolioController < ApplicationController
  def create
    #Creates a new portfolio of the user if it does not exist
    if Portfolio.where(user_id: current_user.id, portfolio_name: params[:portfolio_name]).empty?
      new_portfolio = Portfolio.new(portfolio_name: params[:portfolio_name], user_id: current_user.id)
      new_portfolio.save
    else
      flash[:alert] = "Portfolio already exists"
      redirect_back(fallback_location: dashboard_path)
    end


  end

end
