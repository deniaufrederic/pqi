class AddDmdeToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :dmde, :boolean
    add_column :usagers, :date_dmde, :date

    add_column :rencontres, :tel, :boolean
  end
end
