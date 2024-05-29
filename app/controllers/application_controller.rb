class ApplicationController < ActionController::Base
  include ApplicationHelper

  helper_method :user_signed_in?

  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  #Update the token when requested.
  def update_token
    #Checks if the current user has a token
    if !Token.find_by(user_id: current_user.id).nil?
      session[:access_token] = Token.find_by(user_id: current_user.id).access_token
      session[:refresh_token] = Token.find_by(user_id: current_user.id).refresh_token
      session[:last_updated] = Token.find_by(user_id: current_user.id).last_updated
      session[:api_server] = Token.find_by(user_id: current_user.id).api_server

      #updates the access and refresh token if the difference between current time and last updated is more than 30 minutes.
      if Time.now - session[:last_updated] > 1800
        puts "Token being updated"
        #Sends a post request once code is recieved to get access and refresh token
        response = Faraday.get("https://login.questrade.com/oauth2/token?grant_type=refresh_token&refresh_token=#{session[:refresh_token]}")
        #Parses the response to json
        puts JSON.parse(response.body)

        parsedResponse = JSON.parse(response.body)

        #Updates db and session to new tokens
        token_new = Token.find_by(user_id: current_user.id).update(access_token: parsedResponse['access_token'], refresh_token: parsedResponse['refresh_token'], api_server: parsedResponse['api_server'], last_updated: Time.now, user_id: current_user.id)

        session[:access_token] ||= parsedResponse['access_token']
        session[:refresh_token] ||= parsedResponse['refresh_token']
        session[:api_server] ||= parsedResponse['api_server']
        logger.info(parsedResponse['api_server'])
        session[:last_updated] ||= Time.now
      end
    end
  end

end
