class RemoveIndexFromMaraudes < ActiveRecord::Migration
  def change
  	remove_index :maraudes, :date
  end
end
