# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_30_002955) do
  create_schema "crdb_internal"

  create_table "payment_schedules", force: :cascade do |t|
    t.text "distribution_schedule"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "portfolio_stocks", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.text "stock_name"
    t.bigint "number_of_shares"
    t.decimal "share_price"
    t.decimal "avg_share_price"
    t.decimal "total_value"
    t.bigint "payment_schedule_id", null: false
    t.decimal "div_yield"
    t.decimal "div_per_share"
    t.decimal "total_div"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "symbol_id"
    t.text "industry"
    t.date "ex_dividend"
    t.index ["payment_schedule_id"], name: "index_portfolio_stocks_on_payment_schedule_id"
    t.index ["portfolio_id"], name: "index_portfolio_stocks_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "portfolio_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.text "access_token"
    t.text "refresh_token"
    t.bigint "user_id", null: false
    t.datetime "last_updated", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "api_server"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false

    t.unique_constraint ["email"], name: "index_users_on_email"
    t.unique_constraint ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "portfolio_stocks", "payment_schedules"
  add_foreign_key "portfolio_stocks", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "tokens", "users"
end
