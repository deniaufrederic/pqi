class AddVilleToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :ville, :string
  end
end
