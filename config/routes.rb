Rails.application.routes.draw do
  get 'groupes/show'

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
  resources :maraudes, only: [:index, :show, :destroy, :new, :create]
  resources :rencontres, only: [:create, :edit, :update, :destroy]
  post 'new_groupe'   =>  'rencontres#post_groupe'
  delete 'rencontres' =>  'rencontres#destroy_via_form'
  resources :groupes, only: :show

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

  get 'rencontres/groupe/:id',
    :controller => 'rencontres',
    :action     => 'new_groupe',
    :as         => :id_groupe

  get 'maraude-villes/:id',
    :controller => 'maraudes',
    :action     => 'villes',
    :as         => :id_m_villes

  post 'maraude-villes/:id',
    :controller => 'maraudes',
    :action     => 'post_villes',
    :as         => :id_post_villes

  get 'fiche/:id',
    :controller => 'usagers',
    :action     => 'fiche',
    :as         => :id_fiche

  get 'edit_comp/:id',
    :controller => 'usagers',
    :action     => 'edit_comp',
    :as         => :id_edit_comp

  post 'edit_comp/:id',
    :controller => 'usagers',
    :action     => 'post_comp',
    :as         => :id_post_comp

  get 'stats/:date_deb/:date_fin',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates

  get 'stats/:date_deb/:date_fin/:ville',
    :controller => 'stats',
    :action     => 'show',
    :as         => :stats_dates_ville
end