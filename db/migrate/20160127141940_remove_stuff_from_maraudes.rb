class RemoveStuffFromMaraudes < ActiveRecord::Migration
  def change
  	remove_column :maraudes, :rencontres, :text
  	remove_column :maraudes, :signalements, :text
  	remove_column :maraudes, :accompagnements, :text
  end
end
