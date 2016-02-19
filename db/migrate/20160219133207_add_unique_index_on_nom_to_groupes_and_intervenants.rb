class AddUniqueIndexOnNomToGroupesAndIntervenants < ActiveRecord::Migration
  def change
  	add_index :groupes, :nom, unique: true
  	add_index :intervenants, :nom, unique: true
  end
end
