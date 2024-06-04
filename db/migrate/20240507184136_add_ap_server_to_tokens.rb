class AddApServerToTokens < ActiveRecord::Migration[7.1]
  def change
    add_column :tokens, :api_server, :text
  end
end
