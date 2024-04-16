class DashboardController < ApplicationController
  def index

    # Fetches the query
    if params[:query].present?
      flash.now[:message] = "Showing results for Ticker containing '#{params[:query]}'."
    end
  end
end
