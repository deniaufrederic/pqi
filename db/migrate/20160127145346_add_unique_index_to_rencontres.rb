class AddUniqueIndexToRencontres < ActiveRecord::Migration
  def change
  	add_index :rencontres, [:usager_id, :date, :type_renc], :unique => true
  end
end
