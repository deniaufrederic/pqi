class CreateVilles < ActiveRecord::Migration
  def change
    create_table :villes do |t|
      t.string :nom

      t.timestamps null: false
    end

    add_index :villes, :nom, unique: true
  end
end
