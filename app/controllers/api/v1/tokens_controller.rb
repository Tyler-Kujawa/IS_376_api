require 'json'

class Api::V1::TokensController < Api::V1::ApiController
    respond_to :json
  def create
		email = params[:email]
		password = params[:password]
		@user = User.authenticate!(email, password)
		if @user
			@user.reset_authentication_token!
			render :status=>200, :json=>{:message=>"user-logged in", :user=> @user, :token => @user.authentication_token}
		else
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or passoword."}
      return
    end

	end
 
  def destroy
		@user = User.find_by_id(params[:id])
		@user.authentication_token = nil
		@user.save
		render :status=>200, :json=>{:message => "Token expired", :token=>@user.authentication_token}
  end
 
end