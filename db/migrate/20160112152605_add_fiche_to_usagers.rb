class AddFicheToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :fiche, :text
  end
end
