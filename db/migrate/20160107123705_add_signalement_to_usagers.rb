class AddSignalementToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :signalement, :string
  end
end
