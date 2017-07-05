Rails.application.routes.draw do
  get 'home/index'

  resources :blogs
  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]

  root to: 'home#index'

end
