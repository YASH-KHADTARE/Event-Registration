Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users", to: "users#create"
  post "/login", to: "login#login"
  # resources :events
  resources :users do
    collection do
      get 'search'
    end
  end

  resources :events do
    post 'enroll', to: 'registrations#enroll'
    delete 'unenroll', to: 'registrations#unenroll'
  end

  get 'events', to: 'events#index'
  get 'my_events', to: 'registrations#my_events'
  post '/search', to: 'events#search'


  # Defines the root path route ("/")
  # root "posts#index"
end
