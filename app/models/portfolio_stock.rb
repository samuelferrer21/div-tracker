class PortfolioStock < ApplicationRecord
  belongs_to :portfolio
  belongs_to :payment_schedule

end
