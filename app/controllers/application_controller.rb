class ApplicationController < ActionController::Base

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
end
