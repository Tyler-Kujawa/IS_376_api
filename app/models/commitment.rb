class Commitment < ActiveRecord::Base
  attr_accessible :deadline, :description, :issuer_id, :name, :reciever_id, :status, :is_init
	belongs_to :user, :class_name => "User", :foreign_key => :issuer_id 
	belongs_to :commitment_recipient, :class_name => "User", :primary_key => :id, :foreign_key => :reciever_id
	
	#commitment status
	PENDING = 0
	SENT = 1
	ONGOING = 2
	SUBMITTED = 3
	FULFILLED = 4
	APPROVED = 5
	
	scope :request_initialized_by_issuer, where(is_init: true)
	scope :request_not_initialized_by_issuer, where(is_init: false)
	scope :recipient, lambda{|recipient| where(:reciever_id => recipient.id)}
	scope :commitment_requests, where(:status => PENDING) 
	scope :ongoing_commitments, where(:status => ONGOING)
	scope :commitments_submitted_for_approval, where(:status => SUBMITTED)
	scope :fulfilled_commitments, where(:status => FULFILLED)
	scope :commitments_fulfilled_and_approved, where(:status => APPROVED)
	
	def status_as_string
		if status == PENDING
						"Awaiting recipient response"
		elsif status == SENT
						"Commitment Sent: Waiting for recipient to accept."
		elsif status == ONGOING
						"Ongoing"
		elsif status == SUBMITTED
						"Submitted for approval"
		elsif status == FULFILLED
						"Submitted: Waiting for Approval"
		elsif status == APPROVED
						"Both sides have agreed this commitment is completed"
		else
						nil
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
						create!(:name => commitment.name, :deadline => commitment.deadline, :description => commitment.description, :issuer_id => commitment.issuer_id,
																						:reciever_id => commitment.reciever_id.to_i, :status => PENDING, :is_init => true)
						create!(:name => commitment.name, :deadline => commitment.deadline, :description => commitment.description, :issuer_id => commitment.reciever_id.to_i, 
																						:reciever_id => commitment.issuer_id, :status =>  SENT, :is_init => false)
		end
					
		def accept_request(id)
			second_id = id + 1
			transaction do
				update_one_side(id, ONGOING)
				update_one_side(second_id, ONGOING)
			end
		end
					
		def submit_for_approval(id)
			second_id = id + 1
			transaction do
				update_one_side(id, SUBMITTED)
				update_one_side(second_id, FULFILLED)
			end
		end
					
		def approve(id)
			second_id = id + 1
			transaction do
				update_one_side(id, APPROVED)
				update_one_side(second_id, APPROVED)
			end
		end
					
		def update_one_side(id, status)
			link = link(id)
			transaction do
				link.update_attributes!(:status => status)
			end
		end
					
		def link(id)
						find(id)
		end
	end        
end
