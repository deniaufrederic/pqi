class AddSuiviSocialToUsagers < ActiveRecord::Migration
  def change
    add_column :usagers, :dom, :boolean
    add_column :usagers, :dom_org, :string
    add_column :usagers, :dom_adr, :string
    add_column :usagers, :tut, :boolean
    add_column :usagers, :cur, :boolean
    add_column :usagers, :tutcur_org, :string
    add_column :usagers, :suivi, :boolean
    add_column :usagers, :suivi_org, :string
    add_column :usagers, :sejour, :boolean
    add_column :usagers, :cfr, :boolean
    add_column :usagers, :carte_date, :date
  end
end
