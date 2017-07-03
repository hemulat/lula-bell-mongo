Rails.application.routes.draw do
<<<<<<< HEAD
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
=======

  devise_for :admins, :path_prefix => 'd', skip: [:sessions], controllers: { registrations: "registrations" }
  as :admin do
    get 'sign_in', to: 'devise/sessions#new', as: :new_admin_session
    post 'sign_in', to: 'devise/sessions#create', as: :admin_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_session
  end

  resources :admins
  resources :items

  root to: 'home#index'
>>>>>>> 2a7cdb391d6a128c8808401d752d9ec35126310d
end
