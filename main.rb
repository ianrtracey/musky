require 'sinatra'
# require 'sinatra/reloader' if development?
require 'shotgun'
require 'mongoid'
require 'redcarpet'

configure do
	Mongoid.load!("./mongoid.yml")
end

class Page
	include Mongoid::Document
 
	field :title,   type: String
	field :content, type: String
end	


# Routes
get '/pages' do
	@pages = Page.all
	@tile = "Simple CMS: Page List"
	erb :"views/index"
end	
