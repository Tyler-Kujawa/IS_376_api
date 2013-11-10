IS376Api::Application.routes.draw do

	namespace :api, defaults: {format: 'json'} do
		namespace :v1 do
			devise_for :user, :token_authentication_key => 'authentication_key', controllers: {sessions: "api::v1::sessions", registrations: "api::v1::registrations"}
			resources :users, except: [:new, :edit]
			resources :friendships
			resources :commitments
		end
	end
	
	devise_scope :user do
		devise_for :user
		#get "/" => "devise/sessions#new", :as => :user_session
		match "log_out" => "devise/sessions#destroy", :as => "log_out"
		match "sign_up" => "devise/registrations#new", :as => "sign_up"
		
		root to: "devise/sessions#new"
	end
	
	resources :users
	
end
