class PaymentSchedule < ApplicationRecord
  has_many :portfolio_stocks, dependent: :destroy
end
