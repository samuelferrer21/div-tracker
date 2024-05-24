class PortfolioStockAddSymbolId < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolio_stocks, :symbol_id, :text
  end
end
