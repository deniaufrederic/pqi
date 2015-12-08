class AddPqiToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :pqi, :boolean
  end
end
