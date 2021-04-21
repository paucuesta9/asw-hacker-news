Rails.application.routes.draw do
  resources :replies
  resources :comments
  resources :posts
  resources :users
  resources :vote_comments
  resources :vote_posts
  resources :vote_replies
  get '/newest', to: 'posts#newest'
  root :to => 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
