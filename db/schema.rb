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

ActiveRecord::Schema.define(version: 20160224141613) do

  create_table "enfants", force: :cascade do |t|
    t.integer  "usager_id"
    t.string   "nom"
    t.string   "prenom"
    t.string   "sexe"
    t.date     "date_naissance"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "enfants", ["usager_id"], name: "index_enfants_on_usager_id"

  create_table "groupes", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groupes", ["nom"], name: "index_groupes_on_nom", unique: true

  create_table "intervenants", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "ref"
  end

  add_index "intervenants", ["nom"], name: "index_intervenants_on_nom", unique: true

  create_table "intervenants_maraudes", id: false, force: :cascade do |t|
    t.integer "maraude_id"
    t.integer "intervenant_id"
  end

  add_index "intervenants_maraudes", ["intervenant_id"], name: "index_intervenants_maraudes_on_intervenant_id"
  add_index "intervenants_maraudes", ["maraude_id"], name: "index_intervenants_maraudes_on_maraude_id"

  create_table "maraudes", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "cr"
    t.string   "type_maraude"
    t.text     "villes"
  end

  add_index "maraudes", ["date", "type_maraude"], name: "index_maraudes_on_date_and_type_maraude", unique: true
  add_index "maraudes", ["id"], name: "index_maraudes_on_id", unique: true

  create_table "rencontres", force: :cascade do |t|
    t.integer  "usager_id"
    t.date     "date"
    t.string   "type_renc"
    t.boolean  "signale"
    t.string   "signalement"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "prev"
    t.boolean  "dnv"
    t.integer  "nb_enf"
    t.string   "prestas"
    t.boolean  "accomp"
    t.string   "type_accomp"
    t.string   "ville"
  end

  add_index "rencontres", ["usager_id", "date", "type_renc"], name: "index_rencontres_on_usager_id_and_date_and_type_renc", unique: true
  add_index "rencontres", ["usager_id"], name: "index_rencontres_on_usager_id"

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
    t.string   "pqi_histo"
    t.text     "fiche"
    t.integer  "groupe_id"
    t.text     "ressources"
    t.float    "montant"
    t.text     "fiche_jour"
    t.boolean  "dom"
    t.string   "dom_org"
    t.string   "dom_adr"
    t.boolean  "tut"
    t.boolean  "cur"
    t.string   "tutcur_org"
    t.boolean  "suivi"
    t.string   "suivi_org"
    t.boolean  "sejour"
    t.boolean  "cfr"
    t.date     "carte_date"
    t.text     "autres_infos"
    t.string   "prestas_med"
    t.string   "medecin"
    t.text     "medecin_infos"
    t.string   "pb_sante"
    t.text     "infos_sante"
    t.string   "ref"
    t.boolean  "mobil"
  end

  add_index "usagers", ["groupe_id"], name: "index_usagers_on_groupe_id"
  add_index "usagers", ["nom"], name: "index_usagers_on_nom"
  add_index "usagers", ["ville"], name: "index_usagers_on_ville"

  create_table "users", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "prenom"
    t.string   "identifiant"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.boolean  "benev"
  end

  add_index "users", ["identifiant"], name: "index_users_on_identifiant", unique: true

end
