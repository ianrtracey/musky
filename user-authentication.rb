use Warden::Manager do |config|
	# serialize user to session
	config.serialize_into_session{|user| user.id}

	#serialize user from session
	config.serialize_from_session{|id| User.get(id) }

	# configuring strategies
	config.scope_defaults :default,
		strategies: [:password],
		action: 	'auth/unathenticated'
	config.failure_app = self
end

Warden::Strategies.add(:password) do
	def flash
		env['x-rack.flash']
	end
	
	# valid params for authentication
	def valid?
		params['user'] && params['user']['username'] && params['user']['password']
	end
	
	# authentication for user
	def authenticate!
		user = User.first(username: params['user']['username'])
		if user.nil?
			fail!("Invalid username, doesn't exist!")
			flash.error = ""
		elsif user.authenticate(params['user']['password'])
			flash.success = "Logged in"
			success!(user)
		else
			fail!("Login failed.")
		end
	end
end				

# When user reaches a protected route watched by Warden
post '/auth/unathenticated' do
	session[:return_to] = env['warden.options'][:attempted_path]
	puts env['warden.options'][:attempted_path]
	flash[:error] = env['warden'].message || 'You must be logged in to continue'
	redirect '/auth/login'
end

# Ensure user logout and session data removal
get 'auth/logout' do
	env['warden'].raw_session.inspect
	env['warden'].logout
	flash[:success] = "Successfully logged out"
	redirect '/'
end	

get '/protected' do
	env['warden'].authenticate!
	erb :protected
end	