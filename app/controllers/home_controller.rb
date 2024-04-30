class HomeController < ApplicationController
  def index
   @UserIsSignedIn= user_signed_in?
   logger.info(@UserIsSignedIn)

   #Retrieves the authorization code from Questrade
   if @UserIsSignedIn & !params[:code].nil?
     #Sends a post request once code is recieved to get access and refresh token
     response = Faraday.get("https://login.questrade.com/oauth2/token?client_id=YTGdFwCpGjB76WxOJAmmBOem0n1QvA&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=https://div-tracker-tjzx7q7eeq-uc.a.run.app")
     puts JSON.parse(response.body)

    #Insert the tokens to db
    @token_new = Token.new()
    @token_new.access_token = JSON.parse(response.body)["access_token"]
    @token_new.refresh_token = JSON.parse(response.body)["refresh_token"]
    @token_new.save

    #View Token
    @token_view = Token.all
    logger.info(@token_view.inspect)

   end
  end
end
