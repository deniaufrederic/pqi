class AddTypeRencToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :type_renc, :string
  end
end
