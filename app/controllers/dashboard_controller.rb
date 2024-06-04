class DashboardController < ApplicationController
  before_action :authenticate_user_custom!
  def index
    @UserIsSignedIn= user_signed_in?

    #Grabs the portfolio of the user
    @portfolio_of_user = Portfolio.where(user_id: current_user.id)

    # This will contain the stock data for the selected portfolio.
    @selectedPortfolio = nil

    #Grabs the stock data for the selected portfolio
    if !params[:portfolio_id].nil?
      @selectedPortfolio = PortfolioStock.where(portfolio_id: params[:portfolio_id]).all
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

  # Updates and modifies the stock
  def update_stock
    update_token

    puts "stock updated"
    puts "params: #{params[:price]}"
    puts "params: #{params[:number_of_shares]}"
    puts "params: #{params[:portfolio_id]}"
    puts "params: #{params[:holdingIdModify]}"

    #Fetch new stock data from questrade
    stock_information = Faraday.new(url: "#{Token.find_by(user_id: current_user.id).api_server}v1/symbols?ids=#{PortfolioStock.find_by(id: params[:holdingIdModify]).symbol_id}") do |build|
         build.request :authorization, 'Bearer', -> {Token.find_by(user_id: current_user.id).access_token}
         build.response :raise_error
    end

    stock_response = stock_information.get
    stocks_information = JSON.parse(stock_response.body)


    # Determines what type of calculation needed for the total dividends
    def determine_payment_schedule(schedule)
      distribution = nil
      if "Annual" == schedule
        distribution = 1
      elsif "Semi-Annual" == schedule
        distribution = 2
      elsif "Quarterly" == schedule
        distribution = 4
      elsif "Monthly" == schedule
        distribution = 12
      end

      return distribution
    end

    distribution_id = PortfolioStock.find_by(id: params[:holdingIdModify]).payment_schedule_id

    paid = determine_payment_schedule(PaymentSchedule.find(distribution_id).distribution_schedule).to_i

    #input new number of shares to the portfolio
    modify_stock = PortfolioStock.find_by(portfolio_id: params[:portfolio_id], id: params[:holdingIdModify]).update(
      portfolio_id: params[:portfolio_id].to_i,
      number_of_shares: params[:number_of_shares].to_i,
      share_price: stocks_information["symbols"][0]["prevDayClosePrice"].to_f,
      avg_share_price: params[:price].to_f,
      total_value: (params[:number_of_shares].to_f * stocks_information["symbols"][0]["prevDayClosePrice"].to_f),
      div_yield: stocks_information["symbols"][0]["yield"].to_f,
      div_per_share: stocks_information["symbols"][0]["dividend"].to_f,
      total_div: (params[:number_of_shares].to_f * stocks_information["symbols"][0]["dividend"].to_f) * paid.to_f,
      industry: stocks_information["symbols"][0]["industrySector"],
        ex_dividend: stocks_information["symbols"][0]["dividendDate"],
      symbol_id: stocks_information["symbols"][0]["symbolId"]
      )


  end

  #Deletes the stock from portfolio
  def delete_stock
    puts "Delete Stock"

    puts "Delete stock: #{params[:holdingIdDelete]} , #{params[:portfolio_id]}"

    PortfolioStock.find_by(portfolio_id: params[:portfolio_id], id: params[:holdingIdDelete]).destroy


    #Refreshes the webpage
    redirect_to request.referer
  end

  #Updates the portfolio turtbostream to the template update_target
  def update_portfolio
    puts "Updating portfolio"
    respond_to do |format|
      format.turbo_stream { render "dashboard/update_target", locals: { portfolio: Portfolio.where(user_id: current_user.id) }}
    end
  end
end
