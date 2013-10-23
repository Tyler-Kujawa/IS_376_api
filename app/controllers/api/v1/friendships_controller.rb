class Api::V1::FriendshipsController < Api::V1::ApiController
	before_filter :validate_authentication_token!
	
  def create
		@new_friend = User.find(params[:requested_user_id])
		
		if Friendship.request(current_user, @new_friend)
			render :json => {:message => 'Friend request sent.'}, :status => 200
		else
			render :json => {:message => 'Unable to send friend request.'}, :status => 200
		end
	end
	
	def update
		@friendship = Friendship.find(params[:id])
		if @friendship.accept
			render :json => {:message => 'Friend Added.'}, :status => 200
		else
			render :json => {:message => 'Could not add friend.'}, :status => 400
		end
	end
	
	def destroy
		#add remove
	end
end
