class RemoveTypeFromMaraudes < ActiveRecord::Migration
  def change
    remove_column :maraudes, :type, :string
  end
end
