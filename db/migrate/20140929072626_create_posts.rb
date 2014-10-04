class CreatePosts < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
  		t.string :title
  		t.text   :body
  		t.timestamps
  	end
  	Post.create(title: "My first post", body: "And this is the post's content.")
  	Post.create(title: "How to lasso your dog",
  				body: "1. Tie a rope into a lasso. 2. Swing it over its heard
  					  3. Pull gently.")	
    Post.create(title: "Top 10 coffee shops in Austin", body: "1..10: Epoch Coffee, the 24/7 coffee shop.")  					  	
  end

  def down
  	drop_table :posts
end
