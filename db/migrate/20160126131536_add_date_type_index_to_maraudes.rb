class AddDateTypeIndexToMaraudes < ActiveRecord::Migration
  def change
  	add_index :maraudes, [:date, :type_maraude], :unique => true
  end
end
