class SearchController < ApplicationController
  before_action :authenticate_user!
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

    #Fetch extra data
    stock_information = Faraday.new(url: "#{session[:api_server]}v1/symbols?ids=#{params[:symbol_id]}") do |build|
         build.request :authorization, 'Bearer', -> {session[:access_token] }
         build.response :raise_error
       end

      stock_response = stock_information.get
      stocks_information = JSON.parse(stock_response.body)


      puts "test #{stocks_information["symbols"][0]["symbol"]}"
      puts "test #{stocks_information["symbols"][0]["securityType"]}"
      puts "test #{stocks_information["symbols"][0]["symbolId"]}"
      puts "test #{stocks_information["symbols"][0]["description"]}"


  end
end
