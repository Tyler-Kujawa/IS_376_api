class SurveysController < ApplicationController
  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all

    respond_to do |format|
			format.html
		end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @survey = Survey.find(params[:id])
		@commitment = @survey.commitment

    respond_to do |format|
			format.html
		end
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(params[:survey])

    if @survey.save
      render json: @survey, status: :created, location: @survey
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end


  def update
    @survey = Survey.find(params[:id])
		@commitment = @survey.commitment
		@reviewee = User.find(@commitment.reciever_id)
	
		
		if @survey.update_attributes(params[:survey])
			@commitment.survey_completed
      redirect_to root_url
    else
      respond_to do |format|
				format.html
			end
    end
		
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy

    head :no_content
  end
end
