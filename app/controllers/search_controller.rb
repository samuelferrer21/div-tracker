class SearchController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?

    if params[:query].present?
      flash.now[:message] = "Showing results for symbol containing '#{params[:query]}'."

       search_connection = Faraday.new(url: "#{session[:api_server]}v1/symbols/search?prefix=#{params[:query]}") do |build|
         build.request :authorization, 'Bearer', -> {session[:access_token] }
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
  end
end
