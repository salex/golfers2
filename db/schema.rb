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

ActiveRecord::Schema[8.1].define(version: 2025_11_21_235446) do
  create_table "games", force: :cascade do |t|
    t.string "course"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "formed"
    t.integer "group_id", null: false
    t.string "method"
    t.text "par3"
    t.text "skins"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_games_on_group_id"
  end

  create_table "golfers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.text "courses"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "settings"
    t.string "tees"
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "first_name"
    t.integer "group_id", null: false
    t.boolean "is_frozen"
    t.string "last_name"
    t.date "last_played"
    t.string "limited"
    t.string "name"
    t.string "nickname"
    t.string "phone"
    t.integer "pin"
    t.integer "quota"
    t.float "rquota"
    t.string "tee"
    t.datetime "updated_at", null: false
    t.boolean "use_nickname"
    t.index ["group_id"], name: "index_players_on_group_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "back"
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "front"
    t.integer "game_id", null: false
    t.string "limited"
    t.float "other"
    t.float "par3"
    t.integer "player_id", null: false
    t.float "quality"
    t.integer "quota"
    t.float "skins"
    t.integer "team"
    t.string "tee"
    t.integer "total"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["player_id"], name: "index_rounds_on_player_id"
  end

  create_table "stashes", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.date "date"
    t.date "due_date"
    t.text "hash_data"
    t.bigint "ref_id"
    t.string "remarks"
    t.string "slim"
    t.bigint "stashable_id"
    t.string "stashable_type"
    t.string "status"
    t.text "text_data"
    t.string "title"
    t.string "type"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "fullname"
    t.integer "group_id", null: false
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  add_foreign_key "games", "groups"
  add_foreign_key "players", "groups"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players"
  add_foreign_key "users", "groups"
end
