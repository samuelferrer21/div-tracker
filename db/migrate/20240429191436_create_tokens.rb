class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.text :access_token
      t.text :refresh_token
      t.references :user, null: false, foreign_key: true
      t.timestamp :last_updated

      t.timestamps
    end
  end
end
