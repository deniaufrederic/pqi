class AddIndexToUsagersStuff < ActiveRecord::Migration
  def change
  	add_index :usagers, :ville
  	add_index :usagers, :signale
  	add_index :usagers, :sexe
  end
end
