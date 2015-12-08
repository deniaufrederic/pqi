class AddStuffToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :adresse, :string
    add_column :usagers, :adresse_précis, :string
    add_column :usagers, :user_id, :string
  end
end
