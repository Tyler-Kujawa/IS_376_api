class UsersController < ApplicationController
	before_filter :validate_user
	
	#landing page 
	def dashboard
		respond_to do |format|
			format.html
		end
	end
	
  def index
    @users = User.all
		respond_to do |format|
			format.html
		end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
		@requests = Commitment.issuer(@user.id)
		@commitments = Commitment.recipient(@user.id)

    respond_to do |format|
			format.html
		end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    if @user.save
    else
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end
end
