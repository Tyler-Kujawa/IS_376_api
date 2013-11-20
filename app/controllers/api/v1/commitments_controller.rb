class Api::V1::CommitmentsController < Api::V1::ApiController
	before_filter :validate_authentication_token!
	
	PENDING = 0
	SENT = 1
	ONGOING = 2
	SUBMITTED = 3
	FULFILLED = 4
	APPROVED = 5
	
	def create
		#Create a commitment request
		#Clean up: move to Commitment model
		@commitment = Commitment.send_commitment_request(Commitment.new(issuer_id: current_user.id, reciever_id: params[:recipient_id], name: params[:commitment_name], description: params[:commitment_description], deadline: Time.parse(params[:deadline])))
		if @commitment
			render json: @commitment
		end
  end

  def show
  end

  def update
	 @commitment = Commitment.find(params[:id])
		if @commitment.status == PENDING
			if @commitment.accept_request
				render json: @commitment
			end
			
		elsif @commitment.status == ONGOING
			if @commitment.submit_for_approval
				render json: @commitment
			end
			
		elsif @commitment.status == SUBMITTED
			if @commitment.approve
				render json: @commitment
			end
			
		else
			render json: @commitment
		end
	end
end
