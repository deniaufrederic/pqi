class RemoveIndexOnDateTypeFromMaraudes < ActiveRecord::Migration
  def change
  	remove_index :maraudes, [:date, :type_maraude]
  end
end
