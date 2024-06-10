class PortfoliostatsController < ApplicationController
  before_action :authenticate_user_custom!
  def index
    @UserIsSignedIn= user_signed_in?
    #Grabs the portfolio of the user
    @portfolio_of_user = Portfolio.where(user_id: current_user.id)

     # Determines what type of calculation needed for the total dividends
     def determine_payment_schedule(schedule)
      distribution = 0
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

    #Grabs the stock data for the selected portfolio
    if !params[:portfolio_id].nil?
      @selectedPortfolio = PortfolioStock.includes(:payment_schedule).where(portfolio_id: params[:portfolio_id]).all

      @selectedPortfolio.each do |stock|
        @totalvalue += stock.total_value.to_f.round(2)
        @totaldividend += stock.total_div.to_f.round(2)

        stockDate = stock.ex_dividend

        #Proccess stocks only with dividend
        if stock.div_yield > 0
          #calculate the div that is distributed on payout which is (# shares *div per share)
          total_div_distributed = stock.div_per_share.to_f * stock.number_of_shares.to_f.round(2)

          #outputs the month name
          date = Date.parse(stockDate.to_s)
          month_name = date.strftime("%B")

          #current date
          currentmonth = stock.ex_dividend
          #Adds to the value of the current ex_dividendmonth
          @calanderValue[month_name] += total_div_distributed.round(2)

          #Adds to according to the schedule
          #6 months from ex dividend
          if determine_payment_schedule(stock.payment_schedule.distribution_schedule) == 2
            #Used to add to the hash
            future = date.advance(months:6).strftime("%B")
            #Advances 3 months from the date and stores it into the variable
            currentmonth = currentmonth.advance(months:6)

            #add to the value of the month
            @calanderValue[future] += total_div_distributed.round(2)
          elsif determine_payment_schedule(stock.payment_schedule.distribution_schedule) == 4
            #3 months from ex dividend
            3.times do |i|
              futureQuarterly = currentmonth.advance(months:3).strftime("%B")
              currentmonth = currentmonth.advance(months:3)

              @calanderValue[futureQuarterly] += total_div_distributed.round(2)

            end
          elsif determine_payment_schedule(stock.payment_schedule.distribution_schedule) == 12
            #1 month from ex dividend date
            11.times do |i|
              futureMonthly = currentmonth.advance(months:1).strftime("%B")

              currentmonth = currentmonth.advance(months:1)
              @calanderValue[futureMonthly] += total_div_distributed.round(2)
            end
          end
        end
      end
    end

  end
end
