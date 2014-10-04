require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:///blog.db"

# Models and Their Definitions
class Post < ActiveRecord::Base
end

# Routes
get "/" do
	@posts = Post.order("created_at DESC")
	erb :"posts/index"
end

get "/posts/new" do
	@title = "New Post"
	@post  = Post.new
	erb :"posts/new"
end

get "/posts/:id" do
	@post = Post.find(params[:id])
	erb :"posts/show"
end	

post "/posts" do
	@post = Post.new(params[:post])
	if @post.save
		redirect "posts/#{@post.id}"
	else
		erb :"posts/new"
	end
end

get "/posts/:id/edit" do
	@post = Post.find(params[:id])
	@title = "Edit Form"
	erb :"posts/edit"
end

put "/posts/:id/edit" do
	@post = Post.find(params[:id])
	if @post.update_attributes(params[:post])
		redirect "/posts/#{@post.id}"
	else
		erb :"posts/edit"
	end
end

delete "posts/:id" do
	@post = Post.find(params[:id]).destroy
	redirect "/"
end

get "/about" do
	@title = "About Me"
	erb :"pages/about"
end




# Helpers
helpers do

	#If the page is assigned, it is is added to the page's title
	def title
		if @title
			"#{@title} | Blog"
		else
			"My blog"
		end
	end

	# Formats ruby timestamps
	def pretty_date(time)
		time.strftime("%d %b %Y")
	end

	def post_show_page?
		request.path_info =~ /\/posts\/d+$/
	end

	def delete_post_button(post_id)
		erb :_delete
	end		

end					