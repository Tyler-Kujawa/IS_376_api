collection @users => :users
extends 'api/v1/users/base_user'

node(:request_friendship_link, :if => lambda {|user| current_user.friends.include?(user) == false }) do |fl|
	api_v1_friendships_path(:params => { :requested_user_id => fl.id}, :method => :post)
end

## node for "accept friendship link" needed

node(:view_profile_link) do |pl|
	api_v1_user_path(pl.id)
end