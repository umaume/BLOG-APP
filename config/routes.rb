Rails.application.routes.draw do
  get "categories/index"
  get "categories/show"
  devise_for :users
  resources :posts do
    resources :comments, except: [:index, :show, :new]
    member do
      post :like
      delete :unlike
    end
    collection do
      get :timeline
      get :search
    end
  end
  resources :users, only: [:show, :edit, :update]
  resources :follows, only: [:create, :destroy]
  resources :categories, only: [:index, :show]
  resources :tags, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"
end
