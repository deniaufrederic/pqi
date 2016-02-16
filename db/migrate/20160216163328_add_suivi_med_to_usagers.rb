class AddSuiviMedToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :prestas_med, :string
    add_column :usagers, :medecin, :string
    add_column :usagers, :medecin_infos, :text
    add_column :usagers, :pb_sante, :string
    add_column :usagers, :infos_sante, :text
  end
end
