Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :create, :update]
  get 'user_edit', to: 'users#edit'
  #post 'user_edit', to: 'users#update'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :folders do
    member do
      resources :favorite_tweets
    end
  end
  resources :favorite_users, only: [:index, :show, :new, :create, :destroy]
end
