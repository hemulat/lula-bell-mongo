Rails.application.routes.draw do

  resources :transactions, except:[:show, :index, :new, :edit] do
    collection do
      get :display
      get :notice
    end
    member do
      get :check_in
      get :check_out
      get :delete
    end
  end

  devise_for :admins, skip: [:sessions],
                      :path_prefix => 'd',
                      controllers: { registrations: "registrations" }
  as :admin do
    get 'sign_in', to: 'devise/sessions#new', as: :new_admin_session
    post 'sign_in', to: 'devise/sessions#create', as: :admin_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_session
  end

  resources :blogs

  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'
  get '/items/see/:class', to: 'items#category', as: :category

  get '/admins', to: 'admins#index', as: :admins
  delete '/admins/:id', to: 'admins#destroy', as: :admin

  resources :items,  except:[:new]

  root 'static#home'

  # get 'static/item_requests'

  get 'static/admin_home'

  resources :item_requests

  post '/psa_posts', to: 'psa_posts#create'
  get '/psa_posts/new', to: 'psa_posts#new', as: :new_psa_post

end
