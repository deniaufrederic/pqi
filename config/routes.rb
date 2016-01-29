Rails.application.routes.draw do
  root					          'sessions#new'
  get 'signup'        =>  'users#new'
  post 'login' 		    =>  'sessions#create'
  delete 'logout'     =>  'sessions#destroy'
  resources :users
  post 'add'		      =>	'usagers#create'
  get 'pqi'			      =>	'usagers#pqi'
  get 'new_inconnu'   =>  'usagers#new_inconnu'
  resources :usagers
  get 'stats'         =>  'stats#show'
  post 'stats'        =>  'stats#create'
  post 'villes'       =>  'maraudes#post_villes'
  resources :maraudes, only: [:index, :show, :destroy, :new, :create]
  resources :rencontres, only: [:create, :edit, :update, :destroy]
  delete 'rencontres' =>  'rencontres#destroy_via_form'

  get	'pqi/:ville',
  	:controller => 'usagers',
  	:action 	  => 'pqi',
		:as 		    => :choix_ville

  get 'rencontres/:id',
    :controller => 'rencontres',
    :action     => 'new',
    :as         => :id_rencontre

  get 'rencontres/destroy/:id',
    :controller => 'rencontres',
    :action     => 'destroy_form',
    :as         => :id_destroy

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