Rails.application.routes.draw do
  get "/categories", to: "categories#index", as: 'categories'
end
