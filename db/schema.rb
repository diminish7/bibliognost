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

ActiveRecord::Schema[8.0].define(version: 2025_03_09_234007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.string "external_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_authors_on_external_identifier", unique: true
  end

  create_table "edition_authors", force: :cascade do |t|
    t.bigint "edition_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edition_id", "author_id"], name: "index_edition_authors_on_edition_id_and_author_id", unique: true
  end

  create_table "editions", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "language_id"
    t.bigint "publisher_id"
    t.string "title", null: false
    t.string "subtitle"
    t.string "edition"
    t.string "contributors", default: [], null: false, array: true
    t.string "external_identifier", null: false
    t.string "isbn_10"
    t.string "isbn_13"
    t.date "published_at"
    t.string "format"
    t.integer "pages"
    t.integer "word_count"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_editions_on_external_identifier", unique: true
    t.index ["language_id"], name: "index_editions_on_language_id"
    t.index ["publisher_id"], name: "index_editions_on_publisher_id"
    t.index ["work_id"], name: "index_editions_on_work_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "external_identifier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_languages_on_external_identifier", unique: true
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
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

  add_foreign_key "edition_authors", "authors"
  add_foreign_key "edition_authors", "editions"
  add_foreign_key "editions", "languages"
  add_foreign_key "editions", "publishers"
  add_foreign_key "editions", "works"
  add_foreign_key "work_authors", "authors"
  add_foreign_key "work_authors", "works"
  add_foreign_key "work_subjects", "subjects"
  add_foreign_key "work_subjects", "works"
end
