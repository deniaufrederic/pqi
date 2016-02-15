class AddAutresInfosToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :autres_infos, :text
  end
end
