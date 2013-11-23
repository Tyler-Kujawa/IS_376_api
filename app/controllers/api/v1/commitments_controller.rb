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
		@commitment = Commitment.new(params[:commitment])
		if Commitment.send_commitment_request(@commitment)
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
	
	def destroy
		@commitment = Commitment.find(params[:id])
		
		if @commitment.decline_commitment
			render json: "Commitment successfully declined"
		else
			render json: "Commitment could not be declined."
		end
	end
end
