class AddIndexToUsersIdentifiant < ActiveRecord::Migration
  def change
  	add_index :users, :identifiant, unique: true
  end
end
