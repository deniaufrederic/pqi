class AddVillesToMaraudes < ActiveRecord::Migration
  def change
    add_column :maraudes, :villes, :text
  end
end
