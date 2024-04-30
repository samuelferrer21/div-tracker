class HomeController < ApplicationController
  def index
   @UserIsSignedIn= user_signed_in?
   logger.info(@UserIsSignedIn)
   if @UserIsSignedIn
     #user id
     puts current_user.id

     #Insert the tokens to db
   end
  end
end
