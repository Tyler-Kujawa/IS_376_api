class Commitment < ActiveRecord::Base
  attr_accessible :deadline, :description, :difficulty_score, 
									:is_init, :issuer_id, :name, :reciever_id, 
									:status
									
	belongs_to :user, class_name: "User", foreign_key: issuer_id
	belongs_to :commitment_recipient, class_name: "User", primary_key: :id, foreign_key: :reciever_id 

	#commitment status
d	
	PENDING = 0
	SENT = 1
	ONGOING = 2
	SUBMITTED = 3
	FULFILLED = 4
	APPROVED = 5
	DECLINED = 6
	
	
	def accept_request
		Commitment.accept_request(id)
	end
	
	def submit_for_approval
		Commitment.submit_for_approval(id)
	end
	
	def approve
		Commitment.approve(id)
	end
	
	class << self
		def send_commitment_request(commitment)
			#commitment attached to issuer
			transaction do
				create!(name: commitment.name, deadline: commitment.deadline, description: commitment.description,
				issuer_id: commitment.issuer_id, reciever_id: commitment.reciever_id, difficulty_score: commitment.difficulty_score, 
				is_init: true, status: PENDING )
				
				#commitment attached to reciever
				create!(name: commitment.name, deadline: commitment.deadline, description: commitment.description,
				issuer_id: commitment.reciever_id, reciever_id: commitment.issuer_id, difficulty_score: commitment.difficulty_score, 
				is_init: false, status: SENT )
			end
		end
		
		#accepts the id of the commitment where the issuer is the intializer of the commitment
		def accept_request(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, ONGOING)
				update_one_side(second_id, ONGOING)
			end
		end
		
		def submit_for_approval(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, SUBMITTED)
				update_one_side(second_id, FULFILLED)
			end
		end
		
		def approve(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, APPROVED)
				update_one_side(second_id, APPROVED)
			end
		end
		
		def decline(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, DECLINED)
				update_one_side(second_id, DECLINED)
			end
		end
		
		def update_one_side(id, status)
			link = link(id)
			transaction do
				link.update_attributes!(status: status)
			end
		end
		
		def link(id)
			find(id)
		end
	end
end
