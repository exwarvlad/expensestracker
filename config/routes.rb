Rails.application.routes.draw do
  get 'expenses_senders/new'
  get 'expenses_senders/create'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'expenses#index'
  resources :expenses, except: :show

  resources :users do
    resource :filter, only: [:update, :reset] do
      put :reset
    end

    resource :expenses_sender, only: [:update, :edit]
    resource :expenses_print, only: [:print] do
      get :print
    end
  end
end
