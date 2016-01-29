class AddDnvToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :dnv, :boolean
  end
end
