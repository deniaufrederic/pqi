class AddVuToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :vu, :boolean
  end
end
