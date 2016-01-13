class AddIndexToUsagersStuff < ActiveRecord::Migration
  def change
  	add_index :usagers, :nom
  	add_index :usagers, :ville
  	add_index :usagers, :signale
  end
end
