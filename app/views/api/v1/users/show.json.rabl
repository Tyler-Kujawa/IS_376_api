object @user 
extends 'api/v1/users/base_user'
attributes :authentication_token

child @friendships => :friendships do 
	#information about friend
	@friendships.each do |friend|
		child :friend => :friend do
			attributes :email => :friend_email, :id => :friend_id
		end
	end
	
	#information about the users relationship with that friend
	attributes :friendship_status
	
	#for friends who have requested a friendship with this friend
	#this is the link to accept this friendship
	node(:accept_friendship_link, :if => lambda {|friendship| friendship.friendship_status < 2}) do |fl|
		api_v1_friendship_path(fl.id, :method => :put)
	end
end