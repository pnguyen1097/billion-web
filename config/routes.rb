Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users

  root to: 'pages#show', id: 'landing'

  post '/subscribe', to: 'subscribe#create', as: 'subscribe'
  resources 'bam_applications', only: [:create]
  resources :projects, only: [:index]
  resources :transactions, only: [:new, :create], path: 'donate'

  # static pages
  get 'privacy' => 'high_voltage/pages#show', id: 'privacy'
  get 'terms' => 'high_voltage/pages#show', id: 'terms'
  get 'story' => 'high_voltage/pages#show', id: 'story'
end
