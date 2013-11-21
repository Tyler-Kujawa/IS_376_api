object @user 
extends 'api/v1/users/base_user'
attributes :authentication_token

child @friendships => :friendships do 
	#information about the users relationship with that friend
	attributes :friendship_status
	#information about friend
	@friendships.each do |friend|
		child :friend => :friend do
			attributes 	:user_name => :friend_user_name,
									:email => :friend_email, 
									:id => :friend_id,
									:first_name => :friend_first_name,
									:last_name => :friend_last_name
		end
	end
	
	
	
	#for friends who have requested a friendship with this friend
	#this is the link to accept this friendship
	
	child @requests => :requests do
		attributes 	:name => :name,
								:deadline => :deadline,
								:description => :description,
								:difficulty_score => :difficulty_score,
								:issuer_id => :issuer_id,
								:reciever_id => :reciever_id,
								:status => :status
	end
	
	child @commitments => :commitments do
		attributes 	:name => :name,
								:deadline => :deadline,
								:description => :description,
								:difficulty_score => :difficulty_score,
								:issuer_id => :issuer_id,
								:reciever_id => :reciever_id,
								:status => :status
	end
	
end