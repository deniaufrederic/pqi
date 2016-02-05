class AddIndexToMaraudes < ActiveRecord::Migration
  def change
  	add_index :maraudes, :id, unique: true
  	add_index :maraudes, [:date, :type_maraude], unique: true
  end
end
