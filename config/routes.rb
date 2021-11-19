Rails.application.routes.draw do
  get "/categories", to: "categories#index", as: 'categories'
  # posts
  get '/posts', to: 'posts#index', as: "posts"
  get '/posts/:id', to: 'posts#show', as: 'post'
  post '/posts', to: 'posts#create'
  put '/posts/:id', to: "posts#update"
  patch '/posts/:id', to: "posts#update"
  delete 'posts/:id', to: "posts#destroy"

  post "/auth/login", to: "auth#login", as: "login"
  post '/auth/register', to: "auth#register", as: "register"
end
