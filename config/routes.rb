Rails.application.routes.draw do

  match ':controller(/:action(/:id))', :via => [:get,:post]

  resources :blogs

  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]

end
