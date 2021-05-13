Rails.application.routes.draw do

  scope "/api/v1" ,defaults: {format: 'json'} do
    #POSTS
    get '/posts/upvoted' => 'api/v1/posts#upvoted'
    get '/posts' => 'api/v1/posts#index'
    post '/posts' => 'api/v1/posts#create'
    get '/posts/:postId' => 'api/v1/posts#show'
    put '/posts/:postId' => 'api/v1/posts#update'
    delete '/posts/:postId' => 'api/v1/posts#destroy'
    post '/posts/:postId/vote' => 'api/v1/posts#upvote'
    delete '/posts/:postId/vote' => 'api/v1/posts#unvote'

    #COMMENTS
    get '/comments' => 'api/v1/comments#index'
    post '/comments' => 'api/v1/comments#create'
    get '/comments/upvoted' => 'api/v1/comments#upvoted'
    get '/comments/:commentId' => 'api/v1/comments#show'
    put '/comments/:commentId' => 'api/v1/comments#update'
    delete '/comments/:commentId' => 'api/v1/comments#destroy'
    post '/comments/:commentId/vote' => 'api/v1/comments#upvote'
    delete '/comments/:commentId/vote' => 'api/v1/comments#unvote'

    #REPLIES
    get '/replies' => 'api/v1/replies#index'
    post '/replies' => 'api/v1/replies#create'
    get '/replies/:replyId' => 'api/v1/replies#show'
    put '/replies/:replyId' => 'api/v1/replies#update'
    delete '/replies/:replyId' => 'api/v1/replies#destroy'
    post '/replies/:replyId/vote' => 'api/v1/replies#upvote'
    delete '/replies/:replyId/vote' => 'api/v1/replies#unvote'

    #USERS
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
