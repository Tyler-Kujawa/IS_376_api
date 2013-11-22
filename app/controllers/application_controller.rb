class ApplicationController < ActionController::Base
	helper_method :avatar_url
	def resource_name
	 :user
	end

	def resource
	 @resource ||= User.new
	end

	def devise_mapping
	 @devise_mapping ||= Devise.mappings[:user]
	end
	
	def after_sign_in_path_for(resource)
		user_path(current_user.id)
	end
	
	def validate_user
	
	end
	
	def avatar_url(user)
		default_url = "#{root_url}images/guest.png"
		gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
		"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
	end
end
