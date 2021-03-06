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

ActiveRecord::Schema.define(version: 20160310142345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enfants", force: :cascade do |t|
    t.integer  "usager_id"
    t.string   "nom"
    t.string   "prenom"
    t.string   "sexe"
    t.date     "date_naissance"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "enfants", ["usager_id"], name: "index_enfants_on_usager_id", using: :btree

  create_table "groupes", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groupes", ["nom"], name: "index_groupes_on_nom", unique: true, using: :btree

  create_table "intervenants", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "ref"
  end

  add_index "intervenants", ["nom"], name: "index_intervenants_on_nom", unique: true, using: :btree

  create_table "intervenants_maraudes", id: false, force: :cascade do |t|
    t.integer "maraude_id"
    t.integer "intervenant_id"
  end

  add_index "intervenants_maraudes", ["intervenant_id"], name: "index_intervenants_maraudes_on_intervenant_id", using: :btree
  add_index "intervenants_maraudes", ["maraude_id"], name: "index_intervenants_maraudes_on_maraude_id", using: :btree

  create_table "maraudes", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "cr"
    t.string   "type_maraude"
    t.text     "villes"
  end

  add_index "maraudes", ["date", "type_maraude"], name: "index_maraudes_on_date_and_type_maraude", unique: true, using: :btree
  add_index "maraudes", ["id"], name: "index_maraudes_on_id", unique: true, using: :btree

  create_table "rencontres", force: :cascade do |t|
    t.integer  "usager_id"
    t.date     "date"
    t.string   "type_renc"
    t.boolean  "signale"
    t.string   "signalement"
    t.text     "details"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "prev"
    t.boolean  "dnv"
    t.integer  "nb_enf"
    t.string   "prestas"
    t.boolean  "accomp"
    t.string   "type_accomp"
    t.string   "ville"
    t.string   "sig_contact"
    t.text     "sig_coords"
    t.string   "sig_structure"
    t.string   "accomp_structure"
    t.boolean  "tel"
    t.integer  "user_id"
  end

  add_index "rencontres", ["usager_id", "date", "type_renc"], name: "index_rencontres_on_usager_id_and_date_and_type_renc", unique: true, using: :btree
  add_index "rencontres", ["usager_id"], name: "index_rencontres_on_usager_id", using: :btree

  create_table "structures", force: :cascade do |t|
    t.string   "nom"
    t.string   "ville"
    t.string   "adresse"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "structures", ["nom"], name: "index_structures_on_nom", unique: true, using: :btree

  create_table "structures_usagers", id: false, force: :cascade do |t|
    t.integer "structure_id"
    t.integer "usager_id"
  end

  add_index "structures_usagers", ["structure_id"], name: "index_structures_usagers_on_structure_id", using: :btree
  add_index "structures_usagers", ["usager_id"], name: "index_structures_usagers_on_usager_id", using: :btree

  create_table "type_rencs", force: :cascade do |t|
    t.string   "nom"
    t.boolean  "mar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.boolean  "dmde"
    t.date     "date_dmde"
    t.boolean  "vu"
  end

  add_index "usagers", ["groupe_id"], name: "index_usagers_on_groupe_id", using: :btree
  add_index "usagers", ["nom"], name: "index_usagers_on_nom", using: :btree
  add_index "usagers", ["ville"], name: "index_usagers_on_ville", using: :btree

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

  add_index "users", ["identifiant"], name: "index_users_on_identifiant", unique: true, using: :btree

  create_table "villes", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "ville_93"
  end

  add_index "villes", ["nom"], name: "index_villes_on_nom", unique: true, using: :btree

  add_foreign_key "enfants", "usagers"
  add_foreign_key "rencontres", "usagers"
  add_foreign_key "usagers", "groupes"
end
