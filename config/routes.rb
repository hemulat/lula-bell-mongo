Rails.application.routes.draw do

  resources :transactions, except:[:show, :index] do
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

  get 'transactions', to: 'transactions#display'

  resources :blogs

  get '/items/new', to: 'items#select', as: :new_item
  post '/items/new', to: 'items#select'
  get '/items/new/:class', to: 'items#new'

  resources :items,  except:[:new]

end
