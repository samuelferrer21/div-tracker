class HomeController < ApplicationController
  def index
   @UserIsSignedIn= user_signed_in?
   logger.info(@test)
  end
end
