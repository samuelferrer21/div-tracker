class CreatePortfolioStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_stocks do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.text :stock_name
      t.integer :number_of_shares
      t.decimal :share_price
      t.decimal :avg_share_price
      t.decimal :total_value
      t.references :payment_schedule, null: false, foreign_key: true
      t.decimal :div_yield
      t.decimal :div_per_share
      t.decimal :total_div

      t.timestamps
    end
  end
end
