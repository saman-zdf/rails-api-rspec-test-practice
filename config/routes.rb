Rails.application.routes.draw do
  get "/categories", to: "categories#index", as: 'categories'
  # posts
  get '/posts', to: 'posts#index', as: "posts"
  get '/posts/:id', to: 'posts#show', as: 'post'

  post "/auth/login", to: "auth#login", as: "login"
  post '/auth/register', to: "auth#register", as: "register"
end
