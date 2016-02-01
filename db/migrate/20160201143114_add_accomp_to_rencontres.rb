class AddAccompToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :accomp, :boolean
    add_column :rencontres, :type_accomp, :string
  end
end
