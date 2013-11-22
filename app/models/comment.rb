class Comment < ActiveRecord::Base
  attr_accessible :commitment_id, :text, :user_id
end
