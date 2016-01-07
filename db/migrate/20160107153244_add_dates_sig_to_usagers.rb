class AddDatesSigToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :dates_sig, :string
    add_column :usagers, :signale, :boolean
  end
end
