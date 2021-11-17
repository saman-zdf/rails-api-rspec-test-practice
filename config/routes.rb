Rails.application.routes.draw do
  get "/categories", to: "categories#index", as: 'categories'
  # posts
  get '/posts', to: 'posts#index', as: "posts"
  get '/posts/:id', to: 'posts#show', as: 'post'
end
