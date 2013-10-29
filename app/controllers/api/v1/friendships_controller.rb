class Api::V1::FriendshipsController < Api::V1::ApiController
	before_filter :validate_authentication_token!
	
  def create
		@new_friend = User.find_by_id(params[:requested_user_id])
		@ongoing_friend_request = Friendship.where(:user_id => current_user.id, :friend_id => @new_friend.id).first
		if @ongoing_friend_request.nil?
			if Friendship.request(current_user, @new_friend)
				@friendship = Friendship.where(:user_id => current_user.id, :friend_id => @new_friend.id).first

				render :json => {:message => 'Friend request sent.', :friendship_id => @friendship}, :status => 200
			else
				render :json => {:message => 'Unable to send friend request.'}, :status => 200
			end
		else
			render :json => {:message => "Friendship request already exists", :friendship_request_exists_confirmation => @friendship.nil?}, :status => 404
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
