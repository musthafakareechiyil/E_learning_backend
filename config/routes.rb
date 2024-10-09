Rails.application.routes.draw do
  post "/users", to: "users#create"
  get "/me", to: "users#me"
  post "/login", to: "auth#login"

  resources :courses
end
