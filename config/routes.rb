Rails.application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  resources :users
  get 'signup' => 'users#new'

  resource :session, only: %i[new create destroy]
  get 'signin' => 'sessions#new'
end
