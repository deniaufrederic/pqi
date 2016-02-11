class AddFicheJourToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :fiche_jour, :text
  end
end
