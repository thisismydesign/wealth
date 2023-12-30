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

ActiveRecord::Schema[7.1].define(version: 2023_12_30_161228) do
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
  add_foreign_key "trades", "assets", column: "from_id"
  add_foreign_key "trades", "assets", column: "to_id"
end
