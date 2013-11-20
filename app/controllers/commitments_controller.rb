class CommitmentsController < ApplicationController

	#commitment status
	
	PENDING = 0
	SENT = 1
	ONGOING = 2
	SUBMITTED = 3
	FULFILLED = 4
	APPROVED = 5
	DECLINED = 6
	
	
  def new
		@commitment = Commitment.new
		@friends = current_user.friends
  end

  def create
		@commitment = Commitment.new(params[:commitment])
		if Commitment.send_commitment_request(@commitment)
			redirect_to user_path(current_user)
		else
			redirect_to new_commitment_path
		end
  end

  def update
		@commitment = Commitment.find(params[:id])
		if @commitment.status == PENDING
			if @commitment.accept_request
				redirect_to user_path(current_user)#, :alert => "#{@commitment.status}Commitment Accepted."
			end
		elsif @commitment.status == ONGOING
			if @commitment.submit_for_approval
				redirect_to user_path(current_user)#, :alert => "You have submitted your commitment for approval."
			end
		elsif @commitment.status == SUBMITTED
			if @commitment.approve
				redirect_to user_path(current_user)#, :alert => "Commitment fulfilled!"
			end
		else
			redirect_to user_path(current_user) #:alert => "something..."
		end
	end

  def show
  end

  def destroy
  end
end
