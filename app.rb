# encoding: UTF-8

require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'rack/csrf'
require 'sequel'
require 'uri'

#use Rack::Session::Cookie, secret: "this"
#use Rack::Csrf, raise: true

ActiveRecord::Base.establish_connection(
	adapter: 'sqlite3',
	database: './busstop.db'
)

class Busstop < ActiveRecord::Base
end

get '/' do
	erb :index
end

get '/search' do
	#@busstops = Busstop.find_by(name: URI.unescape(params[:name]))
	#@busstops = Busstop.all
	#if Busstop.find_by(name: params[:name])
	if Busstop.where("name like '%" + params[:name] + "%'")
		#@busstops = Busstop.find_by(name: params[:name])
		@busstops = Busstop.where("name like '%" + params[:name] + "%'")
	else
		@busstops = Busstop.all
	end
	erb :search
end

get '/busstop/:name' do
	@name = "#{params[:name]}"
	erb :busstop
end

post '/search' do
	redirect to("/search/#{params[:name]}")
end
