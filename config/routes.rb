Rails.application.routes.draw do

  scope "/api/v1" ,defaults: {format: 'json'} do
    #GET POSTS BY DATE
    get '/posts/date' => 'api/v1/posts#date'
    #GET POSTS BY POINTS
    get '/posts/points' => 'api/v1/posts#points'
    
    get '/posts/:postId' => 'api/v1/posts#show'
    put '/posts/:postId' => 'api/v1/posts#update'
    delete '/posts/:postId' => 'api/v1/posts#destroy'
    post '/posts' => 'api/v1/posts#create'
    get '/users/:id' => 'api/v1/users#show'
    put '/users/:id' => 'api/v1/users#update'
    post '/users' => 'api/v1/users#create'
  end

  resources :replies
  resources :comments
  resources :posts
  resources :users
  resources :api
  resources :vote_comments do
  member do
    get 'upvote'
    get 'unvote'
    end
  end
  resources :vote_posts do
  member do
    get 'upvote'
    get 'unvote'
    end
  end
  resources :vote_replies do
  member do
    get 'upvote'
    get 'unvote'
    end
  end
  get '/submit', to: 'posts#new'
  get '/newest', to: 'posts#newest'
  get '/ask', to: 'posts#asks'
  get '/news', to: 'posts#index'
  get '/threads', to: 'comments#threads'
  get '/upvoted_comments', to: 'comments#upvoted'
  get '/auth/:provider/callback' => 'sessions#omniauth'
  get '/logout', :controller => 'sessions', :action => 'destroy'
  get '/user/:id', to: 'users#show'
  get '/submissions', to: 'posts#submitted'
  get '/user/comments/:id', to: 'users#comments'
  root :to => 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
