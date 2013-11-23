class Comment < ActiveRecord::Base
  attr_accessible :commitment_id, :text, :user_id
	#belongs_to :commitment
	#belongs_to :user
end
