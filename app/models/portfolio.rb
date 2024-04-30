class Portfolio < ApplicationRecord
  #Associations
  belongs_to :user

  has_many :stocks
end
