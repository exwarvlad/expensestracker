Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'expenses#index'
  resources :expenses, except: :show

  resources :users do
    resource :filter, only: [:update, :reset] do
      put :reset
    end
  end
end
