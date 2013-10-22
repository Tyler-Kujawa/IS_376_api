class Api::V1::RegistrationsController < Devise::RegistrationsController

	def create
		@user = User.create!(:email => params[:email], :password => params[:password])
		if @user
			@user.reset_authentication_token!
			sign_in(@user)
			render :json => { :response => 'account created', :current_user_email => @user.email, :auth_token => @user.authentication_token }.to_json, :status => :ok 
		end
	end
end