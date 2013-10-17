class Api::V1::ApiController < ApplicationController
	include ActionController::MimeResponds
	include ActionController::Helpers
	include ActionController::Cookies
	include ActionController::ImplicitRender
end
