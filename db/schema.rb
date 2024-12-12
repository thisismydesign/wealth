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

ActiveRecord::Schema[7.1].define(version: 2024_12_04_183119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asset_holders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_holders_on_name", unique: true
  end

  create_table "asset_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_types_on_name", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.string "ticker", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_type_id", null: false
    t.index ["asset_type_id"], name: "index_assets_on_asset_type_id"
    t.index ["ticker"], name: "index_assets_on_ticker", unique: true
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
    t.bigint "asset_holder_id", null: false
    t.bigint "user_id", null: false
    t.index ["asset_holder_id"], name: "index_fundings_on_asset_holder_id"
    t.index ["asset_id"], name: "index_fundings_on_asset_id"
    t.index ["user_id"], name: "index_fundings_on_user_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
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
    t.bigint "asset_holder_id", null: false
    t.bigint "user_id", null: false
    t.index ["asset_holder_id"], name: "index_incomes_on_asset_holder_id"
    t.index ["asset_id"], name: "index_incomes_on_asset_id"
    t.index ["income_type_id"], name: "index_incomes_on_income_type_id"
    t.index ["source_id"], name: "index_incomes_on_source_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "prices", force: :cascade do |t|
    t.string "priceable_type", null: false
    t.bigint "priceable_id", null: false
    t.bigint "asset_id", null: false
    t.decimal "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_prices_on_asset_id"
    t.index ["priceable_type", "priceable_id"], name: "index_prices_on_priceable"
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
    t.bigint "asset_holder_id", null: false
    t.bigint "user_id", null: false
    t.index ["asset_holder_id"], name: "index_trades_on_asset_holder_id"
    t.index ["from_id"], name: "index_trades_on_from_id"
    t.index ["to_id"], name: "index_trades_on_to_id"
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assets", "asset_types"
  add_foreign_key "exchange_rates", "assets", column: "from_id"
  add_foreign_key "exchange_rates", "assets", column: "to_id"
  add_foreign_key "fundings", "asset_holders"
  add_foreign_key "fundings", "assets"
  add_foreign_key "fundings", "users"
  add_foreign_key "incomes", "asset_holders"
  add_foreign_key "incomes", "assets"
  add_foreign_key "incomes", "assets", column: "source_id"
  add_foreign_key "incomes", "income_types"
  add_foreign_key "incomes", "users"
  add_foreign_key "prices", "assets"
  add_foreign_key "trade_pairs", "trades", column: "close_trade_id"
  add_foreign_key "trade_pairs", "trades", column: "open_trade_id"
  add_foreign_key "trades", "asset_holders"
  add_foreign_key "trades", "assets", column: "from_id"
  add_foreign_key "trades", "assets", column: "to_id"
  add_foreign_key "trades", "users"
end
