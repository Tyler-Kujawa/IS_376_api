class UserMailer < ActionMailer::Base
  default from: "group3@relationCapital.com"
	
	def survey_email(user)
		@user = user
		@url = "http://example.com/login"
		mail(to: "comsenzce13@gmail.com", subject: "Fill out your Relationship Capital survey")
	end
end
