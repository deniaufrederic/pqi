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

ActiveRecord::Schema.define(version: 20160108135515) do

  create_table "usagers", force: :cascade do |t|
    t.string   "nom"
    t.string   "prenom"
    t.string   "sexe"
    t.string   "ville"
    t.date     "date_naissance"
    t.string   "tel"
    t.text     "notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "adresse"
    t.string   "adresse_précis"
    t.string   "user_id"
    t.boolean  "pqi"
    t.date     "derniere"
    t.text     "rencontres"
    t.string   "signalement"
    t.string   "dates_sig"
    t.boolean  "signale"
    t.string   "pqi_histo"
  end

  add_index "usagers", ["sexe"], name: "index_usagers_on_sexe"
  add_index "usagers", ["signalement"], name: "index_usagers_on_signalement"
  add_index "usagers", ["ville"], name: "index_usagers_on_ville"

  create_table "users", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "prenom"
    t.string   "identifiant"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["identifiant"], name: "index_users_on_identifiant", unique: true

end
