class AddPrestasToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :prestas, :string
  end
end
