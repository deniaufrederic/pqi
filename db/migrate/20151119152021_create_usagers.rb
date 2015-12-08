class CreateUsagers < ActiveRecord::Migration
  def change
    create_table :usagers do |t|
      t.string :nom
      t.string :prenom
      t.string :sexe
      t.string :ville
      t.date :date_naissance
      t.string :tel
      t.text :notes

      t.timestamps null: false
    end
  end
end
