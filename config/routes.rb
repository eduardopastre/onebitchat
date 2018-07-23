Rails.application.routes.draw do
  root to: 'teams#index'

  mount ActionCable.server => '/cable'

  get '/:slug', to: 'teams#show'
  
  resources :teams, only: [:create, :destroy] do
    post 'invite/:id', to: "teams#invite", on: :collection
  end
  resources :channels, only: [:show, :create, :destroy]
  resources :talks, only: [:show]
  resources :team_users, only: [:create, :destroy]
  
  devise_for :users, :controllers => { registrations: 'registrations' }
end
