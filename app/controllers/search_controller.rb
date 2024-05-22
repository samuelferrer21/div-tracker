class SearchController < ApplicationController
  before_action :authenticate_user!
  rescue_from Faraday::Error, with: :handle_connection_failed
  def index
    @UserIsSignedIn= user_signed_in?

    if params[:query].present?
      update_token
      flash.now[:message] = "Showing results for symbol containing '#{params[:query]}'."

       search_connection = Faraday.new(url: "#{session[:api_server]}v1/symbols/search?prefix=#{params[:query]}") do |build|
         build.request :authorization, 'Bearer', -> {session[:access_token] }
         build.response :raise_error
       end

      begin
        search_connection.get
      rescue Faraday::Error => e
        puts "Error occured"
        raise e
      end

      response = search_connection.get
      stocks = JSON.parse(response.body)
      puts stocks

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
end
