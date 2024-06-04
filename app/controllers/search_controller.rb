class SearchController < ApplicationController
  before_action :authenticate_user_custom!
  rescue_from Faraday::Error, with: :handle_connection_failed
  def index
    @UserIsSignedIn= user_signed_in?

    @portfolios = Portfolio.where(user_id: current_user.id).all

    update_token
    if params[:query].present?

      flash.now[:message] = "Showing results for symbol containing '#{params[:query]}'."

       search_connection = Faraday.new(url: "#{session[:api_server]}v1/symbols/search?prefix=#{params[:query]}") do |build|
         build.request :authorization, 'Bearer', -> {session[:access_token] }
         build.response :raise_error
       end

      begin
        search_connection.get
      rescue Faraday::Error => e
        puts "Error occured"
        puts e.message
        raise e
      end

      response = search_connection.get
      stocks = JSON.parse(response.body)
      #puts stocks

      #get all the symbols
      @symbols = stocks["symbols"].map do |symbol|
        {
          symbol: symbol["symbol"],
          securityType: symbol["securityType"],
          symbolId: symbol["symbolId"],
          description: symbol["description"],
          listingExchange: symbol["listingExchange"],
          currency: symbol["currency"]
        }
      end
    end

    #Redirects the user to the dashboard if any error occurs.
    def handle_connection_failed(exception)
      flash[:message] = "An Error occured. Please try again. and make sure you are connected to Questrade."
      redirect_back(fallback_location: dashboard_path)
    end
  end

  def add_stock
    @UserIsSignedIn= user_signed_in?
    puts "added stock"

    flash[:message] = "Successfully added the stock"
    redirect_to request.referer

    #Insert new stock

    #check if token needs to be updated
    update_token

    #Fetch specific stock data
    stock_information = Faraday.new(url: "#{session[:api_server]}v1/symbols?ids=#{params[:symbol_id]}") do |build|
         build.request :authorization, 'Bearer', -> {session[:access_token] }
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


      #Insert new stock with the retrieved data
      new_stock = PortfolioStock.create(
        portfolio_id: params[:portfolio_id].to_i,
        stock_name: stocks_information["symbols"][0]["symbol"],
        number_of_shares: params[:number_of_shares].to_i,
        share_price: stocks_information["symbols"][0]["prevDayClosePrice"].to_f,
        avg_share_price: stocks_information["symbols"][0]["prevDayClosePrice"].to_f,
        total_value: (params[:number_of_shares].to_f * stocks_information["symbols"][0]["prevDayClosePrice"].to_f),
        payment_schedule_id: params[:distribution_id].to_i,
        div_yield: stocks_information["symbols"][0]["yield"].to_f,
        div_per_share: stocks_information["symbols"][0]["dividend"].to_f,
        total_div: (params[:number_of_shares].to_f * stocks_information["symbols"][0]["dividend"].to_f) * determine_payment_schedule(PaymentSchedule.find(params[:distribution_id].to_i).distribution_schedule),
        industry: stocks_information["symbols"][0]["industrySector"],
        ex_dividend: stocks_information["symbols"][0]["dividendDate"],
        symbol_id: stocks_information["symbols"][0]["symbolId"]
      )
      new_stock.save
  end
end
