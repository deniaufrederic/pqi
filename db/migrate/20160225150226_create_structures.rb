class CreateStructures < ActiveRecord::Migration
  def change
    create_table :structures do |t|
      t.string :nom
      t.string :ville
      t.string :adresse

      t.timestamps null: false
    end

    add_index :structures, :nom, unique: true

    create_table :structures_usagers, id: false do |t|
    	t.belongs_to :structure, index: true
    	t.belongs_to :usager, index: true
    end
  end
end
