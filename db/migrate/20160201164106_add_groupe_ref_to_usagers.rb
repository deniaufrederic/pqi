class AddGroupeRefToUsagers < ActiveRecord::Migration
  def change
    add_reference :usagers, :groupe, index: true, foreign_key: true
  end
end
