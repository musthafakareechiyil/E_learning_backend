Rails.application.routes.draw do
  post "/users", to: "users#create"
  get "/me", to: "users#me"
  post "/login", to: "auth#login"

  resources :courses
  resources :enrollments, only: [:index, :create]
  
  resources :installments do
    member do
      post :pay_installment
    end
  end
  
end
