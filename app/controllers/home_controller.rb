class HomeController < ApplicationController
  def index
   @UserIsSignedIn= user_signed_in?

   #Checks if the current user has a already registered token
   if @UserIsSignedIn
    #Checks if the current user has a token
    if !Token.find_by(user_id: current_user.id).nil?
      session[:last_updated] = Token.find_by(user_id: current_user.id).last_updated


        #updates the access and refresh token if the difference between current time and last updated is more than 30 minutes.
        if Time.now - session[:last_updated] > 1800
          begin
            #Sends a post request once code is recieved to get access and refresh token
            response = Faraday.get("https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=#{Token.find_by(user_id: current_user.id).refresh_token}")

            #Parses the response to json
            parsedResponse = JSON.parse(response.body)

            #Updates db and session to new tokens
            token_new = Token.find_by(user_id: current_user.id).update(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], api_server: parsedResponse['api_server'], last_updated: Time.now, user_id: current_user.id)

            session[:last_updated] ||= Time.now
            rescue => e
            #Remove the old token from db
            Token.find_by(user_id: current_user.id).destroy

            #Sends a flash message telling the user to reconnect the questrade account
            flash.now[:alert] = "Please reconnect your questrade account."
          end
      end
    end
   end

   #Retrieves the authorization code from Questrade if the user doesnt have a current token
   if @UserIsSignedIn & !params[:code].nil?
     #Sends a post request once code is recieved to get access and refresh token
     response = Faraday.get("https://login.questrade.com/oauth2/token?client_id=YTGdFwCpGjB76WxOJAmmBOem0n1QvA&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=https://div-tracker-tjzx7q7eeq-uc.a.run.app")
     #Parses the response to json
     parsedResponse = JSON.parse(response.body)


    if Token.find_by(user_id: current_user.id).nil?
      #Insert the tokens to db if no current token exists
      token_new = Token.new(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], api_server: parsedResponse['api_server'], last_updated: Time.now, user_id: current_user.id)
      token_new.save

      #Save to session and we update it by checking the session and replacing the token and updating the db
      session[:last_updated] ||= Time.now
    else
      #Replaces the current token with the new one
      token_new = Token.find_by(user_id: current_user.id).update(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], api_server: parsedResponse['api_server'], last_updated: Time.now, user_id: current_user.id)

      session[:last_updated] ||= Time.now
    end
   end
  end
end
