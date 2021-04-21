Rails.application.routes.draw do
  devise_for :g_users, controllers: { omniauth_callbacks: 'g_users/omniauth_callbacks' }
  devise_scope :g_users do
    get 'g_users/sign_in', to: 'g_users/sessions#new', as: :new_g_users_session
    get 'g_users/sign_out', to: 'g_users/sessions#destroy', as: :destroy_g_users_session
  end
  resources :replies
  resources :comments
  resources :posts
  resources :users
  resources :vote_comments
  resources :vote_posts
  resources :vote_replies
  get '/newest', to: 'posts#newest'
  get '/asks', to: 'posts#asks'
  get '/upvoted_comments', to: 'comments#upvoted'
  root :to => 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
