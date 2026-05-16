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

ActiveRecord::Schema[8.1].define(version: 2026_05_16_202846) do
  create_table "template_blocks", force: :cascade do |t|
    t.string "color", default: "#3b82f6", null: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes", default: 60, null: false
    t.text "notes"
    t.integer "offset_days", default: 0, null: false
    t.integer "start_minute", default: 540, null: false
    t.integer "template_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_template_blocks_on_template_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "period_type", default: "weekly", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_blocks", force: :cascade do |t|
    t.string "color", default: "#3b82f6", null: false
    t.datetime "created_at", null: false
    t.datetime "end_at", null: false
    t.text "notes"
    t.datetime "start_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["end_at"], name: "index_time_blocks_on_end_at"
    t.index ["start_at"], name: "index_time_blocks_on_start_at"
  end

  add_foreign_key "template_blocks", "templates"
end
