IS376Api::Application.routes.draw do

	namespace :api, defaults: {format: 'json'} do
		namespace :v1 do
			devise_for :user, :token_authentication_key => 'authentication_key', controllers: {sessions: "api::v1::sessions", registrations: "api::v1::registrations"}
			resources :users, except: [:new, :edit]
			resources :friendships
		end
	end

	resources :users
	devise_scope :user do
		devise_for :user
		root :to => "devise/sessions#new"
	end
	
	get "sign_up" => "users#new", :as => "sign_up"
	get "log_in" => "sessions#new", :as => "log_in"
	get "log_out" => "sessions#destroy", :as => "log_out"
end
