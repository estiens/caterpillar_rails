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

ActiveRecord::Schema.define(version: 20170802170932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dose_infos", force: :cascade do |t|
    t.string   "insufflated_dose_units"
    t.string   "insufflated_heavy_dose"
    t.string   "insufflated_max_common_dose"
    t.string   "insufflated_max_light_dose"
    t.string   "insufflated_max_strong_dose"
    t.string   "insufflated_min_common_dose"
    t.string   "insufflated_min_light_dose"
    t.string   "insufflated_min_strong_dose"
    t.string   "insufflated_threshold_dose"
    t.string   "intravenous_dose_units"
    t.string   "intravenous_heavy_dose"
    t.string   "intravenous_max_common_dose"
    t.string   "intravenous_max_light_dose"
    t.string   "intravenous_max_strong_dose"
    t.string   "intravenous_min_common_dose"
    t.string   "intravenous_min_light_dose"
    t.string   "intravenous_min_strong_dose"
    t.string   "intravenous_threshold_dose"
    t.string   "oral_dose_units"
    t.string   "oral_heavy_dose"
    t.string   "oral_max_common_dose"
    t.string   "oral_max_light_dose"
    t.string   "oral_max_strong_dose"
    t.string   "oral_min_common_dose"
    t.string   "oral_min_light_dose"
    t.string   "oral_min_strong_dose"
    t.string   "oral_threshold_dose"
    t.string   "sublingual_dose_units"
    t.string   "sublingual_heavy_dose"
    t.string   "sublingual_max_common_dose"
    t.string   "sublingual_max_light_dose"
    t.string   "sublingual_max_strong_dose"
    t.string   "sublingual_min_common_dose"
    t.string   "sublingual_min_light_dose"
    t.string   "sublingual_min_strong_dose"
    t.string   "sublingual_threshold_dose"
    t.string   "smoked_dose_units"
    t.string   "smoked_heavy_dose"
    t.string   "smoked_max_common_dose"
    t.string   "smoked_max_light_dose"
    t.string   "smoked_max_strong_dose"
    t.string   "smoked_min_common_dose"
    t.string   "smoked_min_light_dose"
    t.string   "smoked_min_strong_dose"
    t.string   "smoked_threshold_dose"
    t.integer  "drug_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["drug_id"], name: "index_dose_infos_on_drug_id", using: :btree
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name"
    t.string   "detection"
    t.string   "dose_summary"
    t.string   "onset_summary"
    t.string   "after_effects"
    t.string   "duration_summary"
    t.text     "effects",                default: [],              array: true
    t.text     "aliases",                default: [],              array: true
    t.string   "drug_summary"
    t.text     "categories",             default: [],              array: true
    t.string   "avoid"
    t.string   "general_advice"
    t.json     "full_response"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "toxicity_info"
    t.string   "chemical_class"
    t.string   "addiction_potential"
    t.string   "cross_tolerance"
    t.string   "time_to_full_tolerance"
    t.string   "time_to_zero_tolerance"
    t.string   "marquis_test"
    t.string   "mandelin_test"
    t.string   "mecke_test"
    t.string   "liebermann_test"
    t.string   "froehde_test"
    t.string   "gallic_acid_test"
    t.string   "ehrlic_test"
    t.string   "folin_test"
    t.string   "robadope_test"
    t.string   "simons_test"
    t.string   "scott_test"
    t.index ["aliases"], name: "index_drugs_on_aliases", using: :gin
    t.index ["name"], name: "index_drugs_on_name", using: :btree
  end

  create_table "interactions", force: :cascade do |t|
    t.integer  "substance_a_id"
    t.integer  "substance_b_id"
    t.string   "status"
    t.text     "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["substance_a_id", "substance_b_id"], name: "index_interactions_on_substance_a_id_and_substance_b_id", unique: true, using: :btree
    t.index ["substance_a_id"], name: "index_interactions_on_substance_a_id", using: :btree
    t.index ["substance_b_id"], name: "index_interactions_on_substance_b_id", using: :btree
  end

end
