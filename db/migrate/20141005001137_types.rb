class Types < ActiveRecord::Migration
 # Integer
 # Decimal
 # Single-line
 # Paragraph
 # Image 


  def up
  	create_table :types do |t|
  		t.string :data_type
  		t.text   :data
  		t.timestamps
  	end				  	
  end

  def down
  	drop_table :types
  end	
end