class Api::V1::ApiController < ApplicationController
	helper_method :validate_authentication_token!, :current_user
	
	def validate_authentication_token!
		@auth_token = params[:authentication_token]
		@user = User.find_by_authentication_token(@auth_token)
		if @user
			render :json => { :message => "You are not authorized to view this page", :user => @user }, :status => 401
		end
	end
	
	def current_user 
		@user = User.find_by_authentication_token(params[:authentication_token])
	end

end
