class HomeController < ApplicationController
  def index
   @UserIsSignedIn= user_signed_in?

   #Retrieves the authorization code from Questrade
   if @UserIsSignedIn & !params[:code].nil?
     #Sends a post request once code is recieved to get access and refresh token
     response = Faraday.get("https://login.questrade.com/oauth2/token?client_id=YTGdFwCpGjB76WxOJAmmBOem0n1QvA&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=https://div-tracker-tjzx7q7eeq-uc.a.run.app")
     #Parses the response to json
     parsedResponse = JSON.parse(response.body)

     logger.info(parsedResponse['access_token'])
     logger.info(parsedResponse['refresh_token'])

    if Token.find_by(user_id: current_user.id).nil?
      #Insert the tokens to db if no current token exists
      token_new = Token.new(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], user_id: current_user.id)
      token_new.save
      #Save to session and we update it by checking the session and replacing the token
      session[:access_token] = parsedResponse['access_token']
      session[:refresh_token] = parsedResponse['refresh_token']
    else
      #Replaces the current token with the new one
      token_new = Token.find_by(user_id: current_user.id).update(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], last_updated: Time.now, user_id: current_user.id)
      token_new.save

      session[:access_token] = parsedResponse['access_token']
      session[:refresh_token] = parsedResponse['refresh_token']
      #Save to session and we update it by checking the session and replacing the token
    end
   end
  end
end
