Rails.application.routes.draw do
  root					'sessions#new'
  get 'signup' 		=>  'users#new'
  post 'login' 		=>  'sessions#create'
  delete 'logout' 	=>  'sessions#destroy'
  resources :users
end