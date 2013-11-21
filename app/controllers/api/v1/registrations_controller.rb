class Api::V1::RegistrationsController < Devise::RegistrationsController

	def create
		@user = User.new(params[:user])
		if @user
			@user.reset_authentication_token!
			sign_in(@user)
			render :json => { message: 'account created', new_user: @user }, status: 200 
		else
			render :json => { message: 'account could not be created'}, :status => 404 
		end
	end
end