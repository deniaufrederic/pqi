class AddSigStuffToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :sig_contact, :string
    add_column :rencontres, :sig_coords, :text
  end
end
