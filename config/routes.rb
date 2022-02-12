Rails.application.routes.draw do
  root to: 'toppages#index'
  
  resources :users, only: [:index, :create, :update]
  get 'signup', to: 'users#new'
  get 'user_edit', to: 'users#edit'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'howto' , to: 'how_to_uses#index'
  
  resources :folders do
    member do
      resources :favorite_tweets
    end
  end
  resources :favorite_users, only: [:index, :show, :new, :create, :destroy]
end
