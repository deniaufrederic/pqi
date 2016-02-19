class CreateMaraudesAndIntervenants < ActiveRecord::Migration
  def change
    create_table :intervenants do |t|
      t.string :nom

      t.timestamps null: false
    end

    create_table :intervenants_maraudes, id: false do |t|
    	t.belongs_to :maraude, index: true
    	t.belongs_to :intervenant, index: true
    end
  end
end
