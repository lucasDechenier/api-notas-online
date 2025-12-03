Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  post 'users/login', to: 'users#login'
  get 'users/me', to: 'users#me'

  # RESTful resources
  resources :schools
  resources :users, except: [:new, :edit]
  resources :students
  resources :subjects
  resources :grades
end
