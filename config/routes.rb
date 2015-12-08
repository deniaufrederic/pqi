Rails.application.routes.draw do
  root					'sessions#new'
  get 'signup' 		=>  'users#new'
  post 'login' 		=>  'sessions#create'
  delete 'logout' 	=>  'sessions#destroy'
  resources :users
  post 'add'		=>	'usagers#create'
  get 'pqi'			=>	'usagers#pqi'
  resources :usagers

  get	'pqi/:ville',
  		:controller => 'usagers',
  		:action 	  => 'pqi',
  		:as 		    => :choix_ville

  get 'rencontre/:id',
      :controller => 'usagers',
      :action     => 'rencontre',
      :as         => :id_rencontre
end