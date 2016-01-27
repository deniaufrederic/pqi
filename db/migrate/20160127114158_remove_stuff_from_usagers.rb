class RemoveStuffFromUsagers < ActiveRecord::Migration
  def change
  	remove_column :usagers, :type_renc, :string
  	remove_column :usagers, :details, :text
  	remove_index :usagers, :signale
  	remove_column :usagers, :signale, :boolean
  	remove_column :usagers, :signalement, :string
  	remove_column :usagers, :derniere, :date
  	remove_column :usagers, :rencontres, :text
  	remove_column :usagers, :dates_sig, :string
  end
end
