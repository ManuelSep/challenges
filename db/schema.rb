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

ActiveRecord::Schema.define(version: 2024_08_22_124115) do

  create_table "changes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "field", null: false
    t.string "old_value"
    t.string "new_value"
    t.datetime "changed_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "field", "changed_at"], name: "index_changes_on_user_id_and_field_and_changed_at"
    t.index ["user_id"], name: "index_changes_on_user_id"
  end

end
