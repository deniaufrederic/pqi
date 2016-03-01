class CreateTypeRencs < ActiveRecord::Migration
  def change
    create_table :type_rencs do |t|
      t.string :nom
      t.boolean :mar

      t.timestamps null: false
    end
  end
end
