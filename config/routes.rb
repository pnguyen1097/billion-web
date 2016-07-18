Rails.application.routes.draw do
  get 'leaderboard/index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users

  root to: 'pages#show', id: 'landing'

  authenticated :user, lambda { |u| u.admin? } do
    namespace :control_panel do
      root 'dashboard#index'
      resources :transactions, only: [:create]
      resources :competitions, only: [:update]
    end
  end

  post '/subscribe', to: 'subscribe#create', as: 'subscribe'
  resources 'bam_applications', only: [:create]
  resources :projects, only: [:index]

  resources :transactions, only: [:new, :create], path: 'donate', constraints: lambda { |request|
    Competition.current_competition.open_donation
  }

  get '/leaderboard' => 'leaderboard#index', as: :leaderboard
  get '/leaderboard/data' => 'leaderboard#data', as: :leaderboard_data

  # static pages
  get 'privacy' => 'high_voltage/pages#show', id: 'privacy'
  get 'terms' => 'high_voltage/pages#show', id: 'terms'
  get 'story' => 'high_voltage/pages#show', id: 'story'
end
