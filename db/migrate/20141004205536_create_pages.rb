class CreatePages < ActiveRecord::Migration
  def up
  	create_table :pages do |t|
  		t.string :title
  		t.text   :body
  		t.timestamps
  	end
  	Post.create(title: "About", body: "Write your about page")				  	
  end

  def down
  	drop_table :pages
  end	
end