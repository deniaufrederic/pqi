class AddBenevToUsers < ActiveRecord::Migration
  def change
    add_column :users, :benev, :boolean
  end
end
