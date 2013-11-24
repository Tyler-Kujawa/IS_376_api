class User < ActiveRecord::Base
	
	##	.friendships()
	#		Calling friendships on a @user will return the 
	#		friendships associated with @user.
	#		NOT that @user 's friends.
	has_many :friendships, :dependent => :destroy
	
	##	.friends() 
	#		Calling friends on a @user returns an array of the users
	#		these are the associations where:
	#
	#		:user_id => @user.id, and :friend_id => associated_user.id
	#		
	#		The sender's (the user calling the method) id is always used
	#		as the user_id when searching the database for these records. 
	has_many :friends, :through => :friendships, :primary_key => :friend_id
	
	## .commitments()
	has_many :commitments, foreign_key: :issuer_id
	
	## .commitment_recipients()
	has_many :commitment_recipients, through: :commitments, primary_key: :reciever_id
	
	#		Modules from devise for authentication.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
				 :token_authenticatable
  before_save :ensure_authentication_token
	#		Attributes belonging to the User model/object;
	#		refer to database fields -- can be read and written to.
  attr_accessible :user_name, :first_name, :last_name, :r_c_score,
									:email, :password, :password_confirmation, 
									:authentication_token
									
	#		validations go here
	

	#		User.authenticate!(email, password)
	#		takes an email and password (from form params[])
	#		and returns a user object if these are valid,
	#		or nil if not.
	def self.authenticate!(email, password)
		user = find_by_email(email)
		unless user.nil?
			user.valid_password?(password) ? user : nil
		else
			nil
		end
  end

  #   Searches all users with string,
  #   if no arg passed, returns all users
  def self.search(search, current_user)
    if search
      find(:all, :conditions => ['user_name LIKE ?', "%#{search}%"])
    else
      find(:all, :conditions => (current_user ? ["id != ?", current_user.id] : []))
    end
  end
	
end
