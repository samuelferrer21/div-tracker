class AddIndustryAndExDividendToPortFolioStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolio_stocks, :industry, :text
    add_column :portfolio_stocks, :ex_dividend, :date
  end
end
