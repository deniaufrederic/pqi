class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :nom
      t.string :prenom
      t.string :adresse
      t.string :adresse_précis
      t.string :sexe
      t.date :date_naissance
      t.string :tel
      t.string :groupe_nom

      t.timestamps null: false
    end
  end
end
