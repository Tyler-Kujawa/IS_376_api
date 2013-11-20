class Commitment < ActiveRecord::Base
  attr_accessible :deadline, :description, :difficulty_score, 
									:is_init, :issuer_id, :name, :reciever_id, 
									:status
									
	belongs_to :user, class_name: "User", foreign_key: :issuer_id
	belongs_to :commitment_recipient, class_name: "User", primary_key: :id, foreign_key: :reciever_id 

	#commitment status
	
	PENDING = 0
	SENT = 1
	ONGOING = 2
	SUBMITTED = 3
	FULFILLED = 4
	APPROVED = 5
	DECLINED = 6

	scope :request_initialized_by_issuer, where(is_init: true)
	scope :request_not_initialized_by_issuer, where(is_init: false)
	scope :recipient, lambda{|recipient_id| where(:reciever_id => recipient_id, is_init: true)}
	scope :issuer, lambda{|issuer_id| where(issuer_id: issuer_id, is_init: true)}
	scope :commitment_requests, where(:status => PENDING) 
	scope :ongoing_commitments, where(:status => ONGOING)
	scope :commitments_submitted_for_approval, where(:status => SUBMITTED)
	scope :fulfilled_commitments, where(:status => FULFILLED)
	scope :commitments_fulfilled_and_approved, where(:status => APPROVED)
	
	def status_string
		if status == 0
			"Pending"
		elsif status == 1
			"Sent"
		elsif status == 2
			"Ongoing"
		elsif status == 3
			"Submitted"
		elsif status == 4
			"Fulfilled"
		elsif status == 5
			"Verified by issuer"
		elsif status == 6
			"Declined"
		else
			"Invalid -- error"
		end
	end

	
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
				update_one_side(inverse_commitment_id, ONGOING)
			end
		end
		
		def submit_for_approval(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, SUBMITTED)
				update_one_side(inverse_commitment_id, FULFILLED)
			end
		end
		
		def approve(id)
			@commitment = Commitment.find(id)
			inverse_commitment_id = id + 1
			@recipient = User.find(@commitment.reciever_id)
			transaction do
				update_one_side(id, APPROVED)
				update_one_side(inverse_commitment_id, APPROVED)
				@recipient.r_c_score += 1
				@recipient.save
			end
		end
		
		def decline(id)
			inverse_commitment_id = id + 1
			transaction do
				update_one_side(id, DECLINED)
				update_one_side(inverse_commitment_id, DECLINED)
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
