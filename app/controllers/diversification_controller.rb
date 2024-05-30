class DiversificationController < ApplicationController
  def index
    #Grabs the portfolio of the user
    @portfolio_of_user = Portfolio.where(user_id: current_user.id)

    # This will contain the stock data for the selected portfolio.
    @selectedPortfolio = nil
    @totalvalue = 0.0

    #Grabs the stock data for the selected portfolio
    if !params[:portfolio_id].nil?
      @selectedPortfolio = PortfolioStock.where(portfolio_id: params[:portfolio_id]).all

      @selectedPortfolio.each do |stock|
        @totalvalue += stock.total_value.to_f.round(2)
      end
    end





  end
end
