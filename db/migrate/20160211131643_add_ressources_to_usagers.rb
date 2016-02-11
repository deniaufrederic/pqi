class AddRessourcesToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :ressources, :text
    add_column :usagers, :montant, :float
  end
end
