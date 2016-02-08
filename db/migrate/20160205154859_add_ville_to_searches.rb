class AddVilleToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :ville, :string
  end
end
