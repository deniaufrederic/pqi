class CreateRencontres < ActiveRecord::Migration
  def change
    create_table :rencontres do |t|
      t.references :usager, index: true, foreign_key: true
      t.date :date
      t.string :type_renc
      t.boolean :signale
      t.string :signalement
      t.text :details

      t.timestamps null: false
    end
  end
end
