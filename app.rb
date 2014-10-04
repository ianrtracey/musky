require "sinatra"
require "sinatra/activerecord"
require 'sinatra_warden'

set :database, "sqlite3:///blog.db"

class Application < Sinatra::Base
	register Sinatra::Warden

	get '/admin' do
		authorize!('/login') # require session, redirect to login if not authorized
		haml :admin
	end	

	get 'dashboard' do
		authorize! # require session, redirect to login if not authorized
		haml :dashboard
	end
end		 





# Models and Their Definitions
class Post < ActiveRecord::Base
end

class Page < ActiveRecord::Base
end	

			
# Routes
get "/posts" do
	@posts = Post.order("created_at DESC")
	erb :"posts/index"
end	

get "/" do
	@posts = Post.order("created_at DESC")
	erb :"posts/index"
end
# Posts
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
	@title = "Edit Post"
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


# Pages
get "/pages" do
	@pages = Page.order("created_at DESC")
	erb :"pages/index"
end	 
get "/pages/new" do
	@title = "New Page"
	@page  = Page.new
	erb :"pages/new"
end
get "/pages/:id" do
	@page = Page.find(params[:id])
	erb :"pages/show"
end	
post "/pages" do
	@page = Page.new(params[:page])
	if @page.save
		redirect "pages/#{@page.id}"
	else
		erb :"pages/new"
	end
end
get "/pages/:id/edit" do
	@pages = Page.find(params[:id])
	@title = "Edit Page"
	erb :"pages/edit"
end
put "/pages/:id/edit" do
	@page = Page.find(params[:id])
	if @page.update_attributes(params[:page])
		redirect "/page/#{@page.id}"
	else
		erb :"page/edit"
	end
end
delete "pages/:id" do
	@page = Page.find(params[:id]).destroy
	redirect "/"
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