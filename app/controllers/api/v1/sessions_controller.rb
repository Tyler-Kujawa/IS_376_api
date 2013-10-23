class Api::V1::SessionsController < Devise::SessionsController

	def new
		respond_to do |format|
      format.json do
        render :json => { :message => "log in" }.to_json, :status => :ok
      end
    end
	end
	
	def create
    @user = User.authenticate!(params[:email], params[:password])
		if @user
			sign_in(@user)
			@link_for_current_user = api_v1_user_path(@user).to_s
			@user.reset_authentication_token!
			render :json => { :message => "sign in successful", :current_user_email => @user.email, :auth_token => @user.authentication_token, :link_to_user_dashboard => @link_for_current_user }, :status => 200
    else
			render :json => { :message => "Please enter a valid username and password" }
		end
  end
	
	def destroy
		@auth_token = params[:authentication_token]
		if !@auth_token.nil?
			@user = User.find_by_authentication_token(@auth_token)
			if @user
				@user.authentication_token = nil
				@user.save
				redirect_path = after_sign_out_path_for(resource_name)
				signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
				render :json => {:message => "successfully logged out"}, :status => 200
			else
				render :json => {:message => "Error: user could not be found"}, :status => 404
			end
		else
			render :json => {:message => "Not authorized to sign out without token"}, :status => 404
		end
		
	end
end