class AddVille93ToVilles < ActiveRecord::Migration
  def change
    add_column :villes, :ville_93, :boolean
  end
end
