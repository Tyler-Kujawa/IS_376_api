class Api::V1::ApiController < ApplicationController
	helper_method :validate_authentication_token!, :current_user
	
	def validate_authentication_token!
	end
	
	def current_user 
		@user = User.find_by_authentication_token(params[:authentication_token])
	end

end
