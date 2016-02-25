class AddSigStructureToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :sig_structure, :string
    add_column :rencontres, :accomp_structure, :string
  end
end
