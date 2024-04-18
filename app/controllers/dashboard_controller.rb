class DashboardController < ApplicationController
  def index
    # Fetches the query
    if params[:query].present?
      flash.now[:message] = "Showing results for Ticker containing '#{params[:query]}'."

      response = Faraday.get('https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=RfeXt38_qV89hpNGl4UIfd6NRzC4PgUP0')
      logger.info(response)


      #response = Faraday.get "https://api07.iq.questrade.com/v1/symbols/search?prefix=#{params[:query]}", params do |request|
        #request.headers["Authorization"] = "Bearer KxSIVYI8r6hjaS39xfQExLx7ztyd6hae0"
      #end
      #logger.info(response)
      #puts response.body[]

    end
  end
end
