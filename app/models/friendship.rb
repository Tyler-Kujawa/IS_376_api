class Friendship < ActiveRecord::Base
  attr_accessible :friend_id,:user_id, :friendship_status
	
	belongs_to :user
	belongs_to :friend, :class_name => "User", :foreign_key => :friend_id
	
	#Status variables
	ACCEPTED = 2
	REQUESTED = 1
	PENDING = 0
	
	#methods for finding friendships at specific
	#stages in the friendship process
	scope :accepted_friendships, where(friendship_status: ACCEPTED)
	scope :friendships_requested, where(friendship_status: REQUESTED)
	scope :friendships_pending, where(friendship_status: PENDING)
	
	before_save :is_lonely?
	
	def friendship_status_string
		if friendship_status == 0
			"Pending"
		elsif friendship_status == 1
			"Requested"
		elsif friendship_status == 2
			"Accepted"
		else
			"null"
		end
	end
	
	#prevents users from being friends with themselves
	def is_lonely?
		if self.friend_id == self.user_id
			false
		end
	end
	
	def accept
		Friendship.accept(user_id, friend_id)
	end
	
	def break_up
		Friendship.break_up(user_id, friend_id)
	end
	
	class << self
	
	
		def break_up(user, friend)
			transaction do
				destroy(link(user, friend))
				destroy(link(friend, user))
			end
		end	
		
		def link(user, friend)
			find_by_user_id_and_friend_id(user, friend)
		end
	
		def connect(user, friend)
			transaction do
				request(user, friend)
				accept(friend, user)
			end
		end
		
		def request(user, friend)
			transaction do
				create(:user_id => user.id, :friend_id => friend.id, :friendship_status => PENDING)
				create(:user_id => friend.id, :friend_id => user.id, :friendship_status => REQUESTED)
			end
			true
		end
		
		def accept(user, friend)
			transaction do 
				add_one_side(user, friend)
				add_one_side(friend, user)
			end
		end

		def add_one_side(user, friend)
			link = link(user, friend)  
			link.update_attributes!(:friendship_status => ACCEPTED)
		end
	end
end
