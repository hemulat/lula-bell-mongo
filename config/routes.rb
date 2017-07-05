Rails.application.routes.draw do
  get 'transactions/display'

  get 'transactions/notice'

  get 'transactions/check_in'

  get 'transactions/check_out'

  resources :blogs
  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]

end
