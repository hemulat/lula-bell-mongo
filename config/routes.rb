Rails.application.routes.draw do
  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]
end
