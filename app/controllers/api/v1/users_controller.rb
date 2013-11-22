class Api::V1::UsersController < Api::V1::ApiController
	before_filter :validate_authentication_token!
	
  def index
		@user = current_user
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
		@friendships = @user.friendships
		@requests = Commitment.issuer(@user.id)
		@commitments = Commitment.recipient(@user.id)

		respond_to do |format|
			format.json{ @user }
		end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end
end
