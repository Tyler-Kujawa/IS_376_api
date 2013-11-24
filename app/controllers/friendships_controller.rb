class FriendshipsController < ApplicationController

	def index
		@friendships = current_user.friendships
		@friends = current_user.friends
    @query = params[:search]
    @results = User.search(@query, current_user)
		
		@pending_friendships = current_user.friendships.friendships_pending
		@requested_friendships = current_user.friendships.friendships_requested
		@current_friendships = current_user.friendships.accepted_friendships

	end

	def show
	
	end

	def new
		@friendship = Friendship.new
	end
	
  def create
		@new_friend = User.find(params[:user_id])

		if Friendship.request(current_user, @new_friend)
			flash[:notice] = "Friend request sent"
			redirect_to friendships_path
		else
			flash[:error] = "Unable to send friend request." #Add more specific error message
			redirect_to friendships_path
		end
	end
	
	def update
		@friendship = Friendship.find(params[:id])
		if @friendship.accept
			redirect_to user_path(current_user)
			#render :json => {:message => 'Friend Added.'}, :status => 200
		else
			#error
		end
	end
	
	def destroy
		@friendship = Friendship.find(params[:id])
		@friend_id = @friendship.friend.id
		if Friendship.break_up(current_user.id, @friend_id)
			redirect_to user_path(current_user)
		else
			redirect_to friendships_path
		end
	end
end
