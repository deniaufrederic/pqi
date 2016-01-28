class AddPrevToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :prev, :boolean
  end
end
