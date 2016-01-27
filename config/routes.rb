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
  post 'maraudes' =>  'maraudes#post_villes'
  resources :maraudes
  resources :rencontres, only: [:create, :destroy, :update]

  get	'pqi/:ville',
  	:controller => 'usagers',
  	:action 	  => 'pqi',
		:as 		    => :choix_ville

  get 'rencontres/:id',
    :controller => 'rencontres',
    :action     => 'new',
    :as         => :id_rencontre

  get 'maraude-villes/:id',
    :controller => 'maraudes',
    :action     => 'villes',
    :as         => :id_m_villes

  get 'fiche/:id',
    :controller => 'usagers',
    :action     => 'fiche',
    :as         => :id_fiche

  get 'stats/:date_deb/:date_fin',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates

  get 'stats/:date_deb/:date_fin/:ville',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates_ville
end