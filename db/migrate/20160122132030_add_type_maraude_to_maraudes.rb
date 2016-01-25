class AddTypeMaraudeToMaraudes < ActiveRecord::Migration
  def change
    add_column :maraudes, :type_maraude, :string
  end
end
