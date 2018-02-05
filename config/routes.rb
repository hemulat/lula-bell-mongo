Rails.application.routes.draw do
  root 'static#home'
  get 'reserve/:item_id', to: 'reserves#new', as: :reserve
  get 'reserves/check_out/:reserve_id', to: 'reserves#check_out',
                                        as: :checkout_reserve
  resources :reserves, except: [:new, :show]

  get 'check_in/:id', to: 'transactions#direct_checkin', as: :direct_checkin
  get '/transactions/student/:id', to: 'transactions#student_transactions',
                                  as: :student_activity
  get '/transactions/multiple_check_out', to: 'transactions#multiple_check_out',
                                          as: :multiple_check_out

  resources :transactions, except:[:show, :index, :new, :edit] do
    collection do
      get '/', to: 'transactions#notice'
      get :student
      get :display
      post :student_items
      post :edit_multiple
      put :update_multiple
    end
    member do
      get :check_in
      get :check_out
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
  get '/admin_blogs', to: 'blogs#admin_blogs', as: :admin_blogs

  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'
  get '/items/see/:class', to: 'items#category', as: :category
  get '/search', to: 'items#search', as: :search
  get '/items/:id/transactions', to: 'items#transactions', as: :item_transactions
  get '/items/download', to: 'items#download', as: :download_items #items export

  get '/admins', to: 'admins#index', as: :admins
  delete '/admins/:id', to: 'admins#destroy', as: :admin

  resources :items,  except:[:new]

  root 'static#home'
  get 'static/admin_home'

  resources :item_requests

  resources :psa_posts

  # export links
  get '/reserves/download', to: 'reserves#download', as: :download_reserves
  get '/transactions/download', to: 'transactions#download', as: :download_transactions
  get '/augmented/download', to: 'admins#download', as: :download_augmented

end
