class AddTypeToMaraudes < ActiveRecord::Migration
  def change
    add_column :maraudes, :type, :string
  end
end
