require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'shotgun'
require 'mongoid'
require 'mongo'
require 'redcarpet'

configure do
  Mongoid.load!("./mongoid.yml", :production)
end
class Page
	include Mongoid::Document
 
	field :title,   type: String
	field :content, type: String
end	

	
# Routes
get '/pages' do # Page index
	@pages = Page.all
	@tile = "Simple CMS: Page List"
	erb :"views/index"
end

get 'pages/:id' do
	@page = Page.find(params[:id])
	@title = @page.title
	erb :"views/show"
end		


