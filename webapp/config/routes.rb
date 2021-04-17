Rails.application.routes.draw do
  get 'ask/index'
  get 'posts/asks'
  resources :ask
  resources :posts
  resources :users
  get 'home/helloworld'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
