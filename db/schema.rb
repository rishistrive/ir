# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160328174736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "to_do_id"
    t.string   "content"
    t.integer  "display_order"
    t.boolean  "selected"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "aspects", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "display_order"
    t.text     "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "aspects", ["section_id"], name: "index_aspects_on_section_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "inspector_id"
  end

  add_index "clients", ["inspector_id"], name: "index_clients_on_inspector_id", using: :btree

  create_table "cyas", force: :cascade do |t|
    t.string   "content"
    t.integer  "section_id"
    t.boolean  "completed"
    t.integer  "display_order"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "cyas", ["section_id"], name: "index_cyas_on_section_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "display_order"
    t.string   "caption",            limit: 100
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "images", ["section_id"], name: "index_images_on_section_id", using: :btree

  create_table "inspection_templates", force: :cascade do |t|
    t.integer  "inspector_id"
    t.integer  "report_type_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "inspection_templates", ["inspector_id"], name: "index_inspection_templates_on_inspector_id", using: :btree
  add_index "inspection_templates", ["report_type_id"], name: "index_inspection_templates_on_report_type_id", using: :btree

  create_table "inspector_statements", force: :cascade do |t|
    t.integer  "inspector_id"
    t.integer  "section_type_id"
    t.text     "content"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "statement_type_id"
    t.string   "keyword"
    t.integer  "display_order"
  end

  add_index "inspector_statements", ["inspector_id"], name: "index_inspector_statements_on_inspector_id", using: :btree
  add_index "inspector_statements", ["section_type_id"], name: "index_inspector_statements_on_section_type_id", using: :btree
  add_index "inspector_statements", ["statement_type_id"], name: "index_inspector_statements_on_statement_type_id", using: :btree

  create_table "inspectors", force: :cascade do |t|
    t.string   "email",                  limit: 100, default: "", null: false
    t.string   "first_name",             limit: 25
    t.string   "last_name",              limit: 50
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "password_digest"
    t.string   "company_name",           limit: 150
    t.binary   "logo"
    t.string   "tagline",                limit: 500
    t.string   "license_number"
    t.string   "sponsor_name"
    t.string   "sponsor_license_number"
  end

  create_table "report_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "inspector_id",             null: false
    t.integer  "report_type_id",           null: false
    t.datetime "inspection_datetime"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "rhythm_id"
    t.string   "client_name"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.integer  "inspection_template_id"
    t.string   "scope"
    t.string   "overview_summary"
    t.string   "overview"
  end

  add_index "reports", ["inspector_id"], name: "index_reports_on_inspector_id", using: :btree
  add_index "reports", ["report_type_id"], name: "index_reports_on_report_type_id", using: :btree

  create_table "rhythm_sections", force: :cascade do |t|
    t.integer  "section_type_id"
    t.integer  "rhythm_id"
    t.integer  "completion_order"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "rhythm_sections", ["rhythm_id"], name: "index_rhythm_sections_on_rhythm_id", using: :btree
  add_index "rhythm_sections", ["section_type_id"], name: "index_rhythm_sections_on_section_type_id", using: :btree

  create_table "rhythms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "inspection_template_id"
  end

  add_index "rhythms", ["inspection_template_id"], name: "index_rhythms_on_inspection_template_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "inspector_statement_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rules", ["answer_id"], name: "index_rules_on_answer_id", using: :btree

  create_table "section_types", force: :cascade do |t|
    t.string   "name"
    t.string   "title",        limit: 100
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "inspector_id"
    t.integer  "level"
  end

  add_index "section_types", ["inspector_id"], name: "index_section_types_on_inspector_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "parent_section_id"
    t.integer  "section_type_id"
    t.integer  "display_order"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "inspection_template_id"
    t.integer  "level"
    t.boolean  "inspected"
    t.boolean  "not_inspected"
    t.boolean  "not_present"
    t.boolean  "deficient"
  end

  add_index "sections", ["parent_section_id"], name: "index_sections_on_parent_section_id", using: :btree
  add_index "sections", ["report_id"], name: "index_sections_on_report_id", using: :btree
  add_index "sections", ["section_type_id"], name: "index_sections_on_section_type_id", using: :btree

  create_table "statement_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "display_order"
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "statement_type_id"
    t.integer  "inspector_statement_id"
  end

  add_index "statements", ["inspector_statement_id"], name: "index_statements_on_inspector_statement_id", using: :btree
  add_index "statements", ["section_id"], name: "index_statements_on_section_id", using: :btree
  add_index "statements", ["statement_type_id"], name: "index_statements_on_statement_type_id", using: :btree

  create_table "to_do_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "to_dos", force: :cascade do |t|
    t.string   "content"
    t.integer  "section_id"
    t.integer  "to_do_type_id"
    t.boolean  "completed"
    t.integer  "display_order"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "to_dos", ["section_id"], name: "index_to_dos_on_section_id", using: :btree
  add_index "to_dos", ["to_do_type_id"], name: "index_to_dos_on_to_do_type_id", using: :btree

end
