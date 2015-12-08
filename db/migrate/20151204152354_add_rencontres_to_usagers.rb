class AddRencontresToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :derniere, :date
    add_column :usagers, :rencontres, :text
  end
end
