class AddStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prenom, :string
    add_column :users, :identifiant, :string
    add_column :users, :password_digest, :string
  end
end
