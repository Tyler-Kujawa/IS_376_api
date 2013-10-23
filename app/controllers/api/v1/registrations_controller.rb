class Api::V1::RegistrationsController < Devise::RegistrationsController

	def create
		@user = User.create!(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
		if @user
			@user.reset_authentication_token!
			sign_in(@user)
			render :json => { :message => 'account created', :current_user_email => @user.email, :auth_token => @user.authentication_token, :link_to_user_dashboard => link_to @user }, :status => 200 
		else
			render :json => { :message => 'account could not be created'}, :status => 404 

		end
	end
end