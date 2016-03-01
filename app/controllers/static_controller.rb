class StaticController < ApplicationController
  before_action :logged_in_user,  only: [:guide, :listes, :listes_create, :interv_destroy, :interv_create, :ville_destroy, :ville_create, :type_destroy, :type_create]
  before_action :admin_user,      only: [:listes, :listes_create, :interv_destroy, :interv_create, :ville_destroy, :ville_create, :type_destroy, :type_create]

  def guide
  	delete_groupe
  end

  def listes
    delete_groupe
    @choix = nil
    store_choix
    @liste_choix = [["Intervenants"],
                    ["Villes"],
                    ["Types de rencontre"]]
    @choix = session[:stored_choix] unless session[:stored_choix].nil?
    @intervs = Intervenant.all.order('nom ASC')
    @interv = Intervenant.new
    @villes = Ville.all.order('nom ASC')
    @ville = Ville.new
    @types = TypeRenc.all.order('nom ASC')
    @type = TypeRenc.new
    session.delete(:stored_choix)
  end

  def listes_create
    if !params[:liste][:choix].present?
      flash[:danger] = "Veuillez choisir une liste"
      redirect_to listes_path
    else
      redirect_to listes_choix_path(choix: params[:liste][:choix].split(' ').first)
    end
  end

  def interv_destroy
    Intervenant.find(params[:id]).destroy
    flash[:success] = "Intervenant supprimé"
    redirect_to listes_choix_path(choix: "Intervenants")
  end

  def interv_create
    @interv = Intervenant.new(interv_params)
    if @interv.save
      flash[:success] = "Intervenant créé"
      redirect_to listes_choix_path(choix: "Intervenants")
    elsif @interv.nom.blank?
      flash[:danger] = "Problème rencontré : veuillez rentrer le nom de l'intervenant à ajouter"
      redirect_to listes_choix_path(choix: "Intervenants")
    else
      flash[:danger] = "Problème rencontré : cet intervenant existe déjà"
      redirect_to listes_choix_path(choix: "Intervenants")
    end
  end

  def ville_destroy
    Ville.find(params[:id]).destroy
    flash[:success] = "Ville supprimée"
    redirect_to listes_choix_path(choix: "Villes")
  end

  def ville_create
    @ville = Ville.new(ville_params)
    if @ville.save
      flash[:success] = "Ville créée"
      redirect_to listes_choix_path(choix: "Villes")
    elsif @ville.nom.blank?
      flash[:danger] = "Problème rencontré : veuillez rentrer le nom de la ville à ajouter"
      redirect_to listes_choix_path(choix: "Villes")
    else
      flash[:danger] = "Problème rencontré : cette ville existe déjà"
      redirect_to listes_choix_path(choix: "Villes")
    end
  end

  def type_destroy
    TypeRenc.find(params[:id]).destroy
    flash[:success] = "Type de rencontre supprimé"
    redirect_to listes_choix_path(choix: "Types")
  end

  def type_create
    @type = TypeRenc.new(type_params)
    if @type.save
      flash[:success] = "Type de rencontre créé"
      redirect_to listes_choix_path(choix: "Types")
    elsif @type.nom.blank?
      flash[:danger] = "Problème rencontré : veuillez rentrer le nom du type de rencontre à ajouter"
      redirect_to listes_choix_path(choix: "Types")
    else
      flash[:danger] = "Problème rencontré : ce type de rencontre existe déjà"
      redirect_to listes_choix_path(choix: "Types")
    end
  end

  private
    def interv_params
      params.require(:interv).permit(:nom)
    end

    def ville_params
      params.require(:ville).permit(:nom,
                                    :ville_93)
    end

    def type_params
      params.require(:type).permit( :nom,
                                    :mar)
    end
end
