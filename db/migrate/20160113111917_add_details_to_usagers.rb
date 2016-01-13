class AddDetailsToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :details, :text
  end
end
