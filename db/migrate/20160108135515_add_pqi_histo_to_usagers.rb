class AddPqiHistoToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :pqi_histo, :string
  end
end
