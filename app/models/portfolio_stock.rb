class PortfolioStock < ApplicationRecord
  belongs_to :portfolio
  belongs_to :payment_schedule

  has_one :payment_schedule
end
