Rails.application.routes.draw do
  resources :items
  get '/select', to: 'items#select'
  post '/select', to: 'items#select'
end
