class CreateEnfants < ActiveRecord::Migration
  def change
    create_table :enfants do |t|
      t.references :usager, index: true, foreign_key: true
      t.string :nom
      t.string :prenom
      t.string :sexe
      t.date :date_naissance

      t.timestamps null: false
    end
  end
end
