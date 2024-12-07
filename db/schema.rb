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

ActiveRecord::Schema[8.0].define(version: 2024_11_28_190004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.string "external_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_authors_on_external_identifier", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "work_authors", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "author_id"], name: "index_work_authors_on_work_id_and_author_id", unique: true
  end

  create_table "work_subjects", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id", "subject_id"], name: "index_work_subjects_on_work_id_and_subject_id", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "title", null: false
    t.string "external_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_works_on_external_identifier", unique: true
  end

  add_foreign_key "work_authors", "authors"
  add_foreign_key "work_authors", "works"
  add_foreign_key "work_subjects", "subjects"
  add_foreign_key "work_subjects", "works"
end
