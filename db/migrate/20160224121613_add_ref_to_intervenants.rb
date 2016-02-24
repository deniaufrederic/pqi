class AddRefToIntervenants < ActiveRecord::Migration
  def change
    add_column :intervenants, :ref, :boolean
    add_column :usagers, :ref, :string
    add_column :usagers, :mobil, :boolean
  end
end
