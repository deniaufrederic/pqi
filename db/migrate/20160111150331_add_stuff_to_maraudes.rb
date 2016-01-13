class AddStuffToMaraudes < ActiveRecord::Migration
  def change
    add_column :maraudes, :signalements, :text
    add_column :maraudes, :accompagnements, :text

    add_index :maraudes, :date, unique: true
  end
end
