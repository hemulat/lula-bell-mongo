Rails.application.routes.draw do

  devise_for :admins, :path_prefix => 'd', skip: [:sessions], controllers: { registrations: "registrations" }
  as :admin do
    get 'sign_in', to: 'devise/sessions#new', as: :new_admin_session
    post 'sign_in', to: 'devise/sessions#create', as: :admin_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_session
  end

  resources :admins

  root to: 'home#index'

  resources :blogs
  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]

end
