Rails.application.routes.draw do
  get "/categories", to: "categories#index", as: 'categories'
  # posts
  get '/posts', to: 'posts#index', as: "posts"
end
