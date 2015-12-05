Rails.application.routes.draw do
  root 'static_pages#home'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :categories
  resources :fixed_assets, except: [:index]
  resources :unfixed_assets, except: [:index]
  
  post '/check-out/:id', to: 'unfixed_assets#check_out', as: 'check_out'
  post '/check-in/:id', to: 'unfixed_assets#check_in', as: 'check_in'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
end