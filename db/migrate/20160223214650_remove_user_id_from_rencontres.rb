class RemoveUserIdFromRencontres < ActiveRecord::Migration
  def change
    remove_column :rencontres, :user_id, :integer
  end
end
