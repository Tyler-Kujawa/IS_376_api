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
			@user.reset_authentication_token!
			render :json => { :signed_in_confirmation => true, :current_user_email => @user.email, :auth_token => @user.authentication_token }.to_json, :status => :ok
    else
			render :json => { :message => "Please enter a valid username and password" }
		end
  end
	
	def destroy
		@user = User.find_by_authentication_token(params[:authentication_token])
		if @user
			@user.authentication_token = nil
			@user.save
			redirect_path = after_sign_out_path_for(resource_name)
			signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
			render :json => {:message=> "successfully logged out", :logged_in? => @user.authentication_token.nil? }
		else
			render :json => {:message => "Error: user could not be found"}
		end
		
	end
end