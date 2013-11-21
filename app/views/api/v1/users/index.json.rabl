collection @users => :users
extends 'api/v1/users/base_user'

@friendships = @user.friendships 
child @friendships.where(:user_id => current_user.id).first => :friendship do 
	attribute :friendship_status
end