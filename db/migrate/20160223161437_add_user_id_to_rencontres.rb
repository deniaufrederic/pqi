class AddUserIdToRencontres < ActiveRecord::Migration
  def change
    add_column :rencontres, :user_id, :integer
  end
end
