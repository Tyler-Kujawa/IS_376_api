IS376Api::Application.routes.draw do

	namespace :api, defaults: {format: 'json'} do
		namespace :v1 do
			devise_for :user, :token_authentication_key => 'authentication_key', controllers: {sessions: "api::v1::sessions", registrations: "api::v1::registrations"}
			resources :users, except: [:new, :edit]
			resources :friendships
			resources :commitments
			resources :surveys
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
	resources :commitments
	resources :friendships
	resources :surveys
	
	match "/friendships/delete/:id" => "friendships#destroy", as: "delete_friendship"
	match "/friendships/update/:id" => "friendships#update", as: "update_friendship"	
	
	match "/commitments/delete/:id" => "commitments#destroy", as: "delete_commitment"
	match "/commitments/update/:id" => "commitments#update", as: "update_commitment"	

	match "/surveys/update/:id" => "surveys#update", as: "complete_survey"
	
	
end
