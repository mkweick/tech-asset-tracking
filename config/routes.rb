Rails.application.routes.draw do
  root 'static_pages#home'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :categories
  resources :fixed_assets, except: [:show]
  resources :unfixed_assets, except: [:show]
  
  get '/asset-management', to: 'static_pages#asset_admin', as: 'asset_management'
  post '/check-out/:id', to: 'unfixed_assets#check_out', as: 'check_out'
  post '/check-in/:id', to: 'unfixed_assets#check_in', as: 'check_in'
end