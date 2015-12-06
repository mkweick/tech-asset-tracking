Rails.application.routes.draw do
  root 'static_pages#home'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :categories
  resources :fixed_assets, except: [:show]
  resources :unfixed_assets, except: [:show]
  
  get '/asset_management', to: 'static_pages#asset_admin', as: 'asset_management'
  post '/assign/:id', to: 'fixed_assets#assign', as: 'assign'
  post '/unassign/:id', to: 'fixed_assets#unassign', as: 'unassign'
  post '/check_out/:id', to: 'unfixed_assets#check_out', as: 'check_out'
  post '/check_in/:id', to: 'unfixed_assets#check_in', as: 'check_in'
end