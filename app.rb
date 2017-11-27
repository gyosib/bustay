# encoding: UTF-8

require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'rack/csrf'
require 'sequel'
require 'uri'
require 'logger'
require 'date'
require 'rack/flash'

enable :session
use Rack::Session::Cookie, secret: "this"
use Rack::Csrf, raise: true
use Rack::Protection
use Rack::Flash

helpers do
	def csrf_tag
		Rack::Csrf.csrf_tag(env)
	end
	def csrf_token
		Rack::Csrf.csrf_token(env)
	end
	def h(str)
		Rack::Utils.escape_html(str)
	end
end

	set :environment, :production

	ActiveRecord::Base.establish_connection(
		adapter: 'sqlite3',
		database: './busstop.db'
	)

	class Busstop < ActiveRecord::Base
	end
	class Tweet < ActiveRecord::Base
	end
	class Bookmark < ActiveRecord::Base
	end
	class User < ActiveRecord::Base
		has_secure_password
	end

	get '/' do
		#if session[:user_id] != nil
		unless	@user = User.find_by_id(session[:user_id])
			session[:user_id] = nil
		else
			@bookmarks = Bookmark.where(user_id: @user.id)
			@busstops = []
			@bookmarks.each do |bookmark|
				@busstops.push(Busstop.find_by_id(bookmark.busstop))
			end
		end
		erb :index
	end

	get '/search' do
		#@busstops = Busstop.find_by(name: URI.unescape(params[:name]))
		#@busstops = Busstop.all
		#if Busstop.find_by(name: params[:name])
		if Busstop.where("name like '%" + params[:name] + "%'")
			#@busstops = Busstop.find_by(name: params[:name])
			@busstops = Busstop.where("name like '%" + params[:name] + "%'")
			@busstops = @busstops.where("pre like '%" + params[:pre] + "%'")
			@busstops = @busstops.where("muni like '%" + params[:muni] + "%'")
		else
			@busstops = Busstop.all
		end
		erb :search
	end

	get '/create' do
		erb :create
	end

	get '/create_user' do
		erb :create_user
	end

	get '/login' do
		@success = true
		erb :login
	end

	post '/create' do
		@busstop = Busstop.create(name: params[:name], pre: params[:place1], muni: params[:place2])
		redirect to("/busstop/"+@busstop.id.to_s)
	end

	post '/create_user' do
		@user = User.create(name: params[:name], password: params[:password])
		redirect to("/")
	end

	post '/login' do
		user = User.find_by(name: params[:name])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			session[:user_name] = user.name
			p session[:user_id]
			redirect "/"
		else
			flash[:hoge] = "ログインに失敗しました"
		end
	end

	post '/logout' do
		session[:user_id] = nil
	end

	post '/tweet' do
		Tweet.create(place: params[:name], goto: params[:goto], text: params[:text], name: session[:user_name], day: Time.now.in_time_zone('Tokyo'))
		redirect to("/busstop/"+params[:name])
	end	

	post '/favorite' do
		unless Bookmark.find_by(user_id: session[:user_id], busstop: params[:id])
			Bookmark.create(user_id: session[:user_id], busstop: params[:id]) unless session[:user_id] == nil
		end
	end

	post '/des_favorite' do
		if busstop = Bookmark.find_by(user_id: session[:user_id], busstop: params[:id])
			busstop.destroy
		end
	end

	get '/busstop/:name' do
		@name = "#{params[:name]}"
		@place = Busstop.find(params[:name]).name
		#@tweets = Tweet.where(place: :name)
		@tweets = Tweet.where("place like '%" + params[:name] + "%'")
		@bookmark = Bookmark.find_by(user_id: session[:user_id], busstop: params[:name])
		erb :busstop
	end

	post '/search' do
		redirect to("/search/#{params[:name]}")
	end

	post '/destroy' do
		Busstop.find(params[:id]).destroy
	end
