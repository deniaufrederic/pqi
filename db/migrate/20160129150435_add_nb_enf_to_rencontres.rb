class AddNbEnfToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :nb_enf, :integer
  end
end
