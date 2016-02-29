class StaticController < ApplicationController
  before_action :logged_in_user,  only: [:guide, :listes]
  before_action :admin_user,      only: :listes

  def guide
  	delete_groupe
  end

  def listes
    delete_groupe
    @choix = nil
    store_choix
    @liste_choix = [["Intervenants"],
                    ["Villes"]]
    @choix = session[:stored_choix] unless session[:stored_choix].nil?
    @intervs = Intervenant.all.order('nom ASC')
    session.delete(:stored_choix)
  end

  def listes_create
    if !params[:liste][:choix].present?
      flash[:danger] = "Veuillez choisir une liste"
      redirect_to listes_path
    else
      redirect_to listes_choix_path(choix: params[:liste][:choix])
    end
  end

  def interv_destroy
    Intervenant.find(params[:id]).destroy
    flash[:success] = "Intervenant supprimé"
    redirect_to listes_choix_path(choix: "Intervenants")
  end
end
