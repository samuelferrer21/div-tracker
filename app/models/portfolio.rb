class Portfolio < ApplicationRecord
  #Associations
  belongs_to :user

  has_many :portfolio_stocks, dependent: :destroy
end
