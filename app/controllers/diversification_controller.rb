class DiversificationController < ApplicationController
  before_action :authenticate_user!
  def index
    @UserIsSignedIn= user_signed_in?
    #Grabs the portfolio of the user
    @portfolio_of_user = Portfolio.where(user_id: current_user.id)

     # Determines what type of calculation needed for the total dividends
     def determine_payment_schedule(schedule)
      distribution = nil
      if "Annual" == schedule
        distribution = 1
      elsif "Semi-Annual" == schedule
        distribution = 2
      elsif "Quarterly" == schedule
        distribution = 4
      elsif "Monthly" == schedule
        distribution = 12
      end

      return distribution
    end

    # This will contain the stock data for the selected portfolio.
    @selectedPortfolio = nil
    @totalvalue = 0.0
    @totaldividend = 0.0

    #Array holds the distribution number and stock_id
    @calanderValue={"January"=>0, "February"=>0, "March"=>0, "April"=>0, "May"=>0, "June"=>0, "July"=>0, "August"=>0, "September"=>0, "October"=>0, "November"=>0, "December"=>0}

    datetest = Date.parse("2024-07-02")
    puts "Beginning #{datetest.strftime("%B")}"
    3.times do
      month_nametest = datetest.advance(months:3).strftime("%B")
      datetest = datetest.advance(months:3)
      puts month_nametest

    end


    #Grabs the stock data for the selected portfolio
    if !params[:portfolio_id].nil?
      @selectedPortfolio = PortfolioStock.where(portfolio_id: params[:portfolio_id]).all

      @selectedPortfolio.each do |stock|
        @totalvalue += stock.total_value.to_f.round(2)
        @totaldividend += stock.total_div.to_f.round(2)

        stockDate = stock.ex_dividend

        #Proccess stocks only with dividend
        if stock.div_yield > 0
          #calculate the div that is distributed on payout which is (# shares *div per share)
          total_div_distributed = stock.div_per_share.to_f * stock.number_of_shares.to_f.round(2)

          #Append this value to the proper month and append it to the distribution schedule set in db
          #Appends to the month name

          #outputs the month name
          date = Date.parse(stockDate.to_s)
          month_name = date.strftime("%B")
          #Adds to the value of the month
          # @calanderValue[month_name] += total_div_distributed
          # #Adds to according to the schedule
          # if determine_payment_schedule(stock.schedule) == 2
          #   #6 months from ex dividend date
          #   #Gets the month from 6 months from ex dividend date
          #   future = date.advance(months:6).strftime("%B")
          #   #add to the value of the month
          #   @calanderValue[future] += total_div_distributed

          # elsif determine_payment_schedule(stock.schedule) == 4
          #   #3 months from ex dividend date

          #   #Gets the month from 6 months from ex dividend date
          #   3.times do |i|
          #     futureQuarterly = date.advance(months:3).strftime("%B")
          #     #add to the value of the month
          #     @calanderValue[futureQuarterly] += total_div_distributed
          #   end


          # elsif determine_payment_schedule(stock.schedule) == 12
          #   #1 month from ex dividend date
          #   #Gets the month from 6 months from ex dividend date
          #   11.times do |i|
          #     futureQuarterly = date.advance(months:1).strftime("%B")
          #     #add to the value of the month
          #     @calanderValue[futureQuarterly] += total_div_distributed
          #   end
          # end

        end

      end
    end

    #Data for the dividend calculator

  end
end
