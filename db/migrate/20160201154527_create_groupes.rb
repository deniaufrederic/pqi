class CreateGroupes < ActiveRecord::Migration
  def change
    create_table :groupes do |t|
      t.string :nom

      t.timestamps null: false
    end
  end
end
