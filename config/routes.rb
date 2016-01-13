Rails.application.routes.draw do
  root					      'sessions#new'
  get 'signup'    =>  'users#new'
  post 'login' 		=>  'sessions#create'
  delete 'logout' =>  'sessions#destroy'
  resources :users
  post 'add'		  =>	'usagers#create'
  get 'pqi'			  =>	'usagers#pqi'
  resources :usagers
  get 'stats'     =>  'stats#show'
  post 'stats'    =>  'stats#create'
  get 'maraudes'  =>  'maraudes#index'

  get	'pqi/:ville',
  	:controller => 'usagers',
  	:action 	  => 'pqi',
		:as 		    => :choix_ville

  get 'rencontre/:id',
    :controller => 'usagers',
    :action     => 'rencontre',
    :as         => :id_rencontre

  get 'stats/:date_deb/:date_fin',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates

  get 'stats/:date_deb/:date_fin/:ville',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates_ville
end