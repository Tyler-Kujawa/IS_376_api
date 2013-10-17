class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
	
	def self.authenticate!(email, password)
		user = find_by_email(email)
		unless user.nil?
			user.valid_password?(password) ? user : nil
		else
			nil
		end
	end
	
end
