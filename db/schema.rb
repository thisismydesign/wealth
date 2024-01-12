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

ActiveRecord::Schema[7.1].define(version: 2024_01_12_152059) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asset_sources", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_sources_on_name", unique: true
  end

  create_table "asset_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_types_on_name", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.string "name", null: false
    t.string "ticker"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_type_id", null: false
    t.bigint "asset_source_id", null: false
    t.index ["asset_source_id"], name: "index_assets_on_asset_source_id"
    t.index ["asset_type_id"], name: "index_assets_on_asset_type_id"
    t.index ["name", "asset_type_id", "asset_source_id"], name: "index_assets_on_name_and_type_and_source", unique: true
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.decimal "rate", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id", "to_id", "date"], name: "index_exchange_rates_on_from_to_date", unique: true
    t.index ["from_id"], name: "index_exchange_rates_on_from_id"
    t.index ["to_id"], name: "index_exchange_rates_on_to_id"
  end

  create_table "fundings", force: :cascade do |t|
    t.datetime "date", null: false
    t.decimal "amount", null: false
    t.bigint "asset_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_fundings_on_asset_id"
  end

  create_table "income_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_income_types_on_name", unique: true
  end

  create_table "incomes", force: :cascade do |t|
    t.datetime "date", null: false
    t.bigint "income_type_id", null: false
    t.decimal "amount", null: false
    t.bigint "asset_id", null: false
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_incomes_on_asset_id"
    t.index ["income_type_id"], name: "index_incomes_on_income_type_id"
    t.index ["source_id"], name: "index_incomes_on_source_id"
  end

  create_table "trade_pairs", force: :cascade do |t|
    t.bigint "open_trade_id", null: false
    t.bigint "close_trade_id", null: false
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["close_trade_id"], name: "index_trade_pairs_on_close_trade_id"
    t.index ["open_trade_id"], name: "index_trade_pairs_on_open_trade_id"
  end

  create_table "trades", force: :cascade do |t|
    t.datetime "date", null: false
    t.decimal "from_amount", null: false
    t.decimal "to_amount", null: false
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_trades_on_from_id"
    t.index ["to_id"], name: "index_trades_on_to_id"
  end

  add_foreign_key "assets", "asset_sources"
  add_foreign_key "assets", "asset_types"
  add_foreign_key "exchange_rates", "assets", column: "from_id"
  add_foreign_key "exchange_rates", "assets", column: "to_id"
  add_foreign_key "fundings", "assets"
  add_foreign_key "incomes", "assets"
  add_foreign_key "incomes", "assets", column: "source_id"
  add_foreign_key "incomes", "income_types"
  add_foreign_key "trade_pairs", "trades", column: "close_trade_id"
  add_foreign_key "trade_pairs", "trades", column: "open_trade_id"
  add_foreign_key "trades", "assets", column: "from_id"
  add_foreign_key "trades", "assets", column: "to_id"
end
