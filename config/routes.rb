Rails.application.routes.draw do
  root to: 'teams#index'

  mount ActionCable.server => '/cable'

  get '/:slug', to: 'teams#show', as: :team
  
  resources :teams, only: [:create, :destroy] do
    post 'invite/:id', to: 'teams#invite', on: :collection
    get 'join/:id', to: 'teams#join', on: :collection, as: :join
  end
  resources :channels, only: [:show, :create, :destroy]
  resources :talks, only: [:show]
  resources :team_users, only: [:create, :destroy]
  
  devise_for :users, :controllers => { registrations: 'registrations' }
end
