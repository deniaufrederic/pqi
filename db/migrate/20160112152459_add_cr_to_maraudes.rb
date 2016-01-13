class AddCrToMaraudes < ActiveRecord::Migration
  def change
    add_column :maraudes, :cr, :text
  end
end
