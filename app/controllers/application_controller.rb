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
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(user.email)}"
	end
end
