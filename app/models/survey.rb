class Survey < ActiveRecord::Base
  attr_accessible :commitment_id, :question_1_rating, :question_2_rating, :question_3_rating, :user_id
	
	belongs_to :user
	belongs_to :commitment
end
