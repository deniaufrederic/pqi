class UsagersController < ApplicationController
  before_action :logged_in_user,  only: [:new, :show, :index, :create, :edit, :update, :destroy, :pqi, :fiche, :fiche_jour, :edit_comp, :post_comp]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:edit, :update, :destroy, :fiche, :fiche_jour, :edit_comp, :post_comp]

  def new
    delete_groupe
    session[:stored] = "new"
    @usager = Usager.new
    @villes = [["Ville inconnue"], ["Autre (hors 93)"]]
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    gon.noms = []
    gon.prenoms = []
    Usager.all.each do |u|
      gon.noms << "#{u.nom}"
      gon.prenoms << "#{u.prenom}"
    end
  end

  def index
    delete_groupe
    if params[:search]
      @usagers = Usager.search(params[:search]).paginate(page: params[:page], per_page: 50)
      if @usagers.empty?
        @usagers = Usager.search(params[:search].split('/').reverse.join('-')).paginate(page: params[:page], per_page: 50)
      end
    else
      @usagers = Usager.paginate(page: params[:page], per_page: 50)
    end
    @vus = Usager.where(vu: false).order('nom ASC')
  end

  def post_vus
    usagers_vus = params[:usagers][:vus].reject{ |a| a == '0' }
    usagers_vus.each do |v|
      Usager.find(v).update_attribute(:vu, true)
    end
    redirect_to usagers_path
  end

  def show
    delete_groupe
  	@usager = Usager.find(params[:id])
  end

  def create
    @usager = Usager.new(usager_params)
    @usager.user_id = current_user.id
    @usager.vu = false
    if params[:add_inconnu]
      if !params[:usager][:sexe]
        @usager.sexe = ""
      end
      @usager.nom = ""
      @usager.prenom = "Inconnu" if @usager.sexe == "Mr"
      @usager.prenom = "Inconnue" if @usager.sexe == "Mme"
      @usager.prenom = "Inconnu(e)" if @usager.sexe == ""
    end
    if @usager.save
      if @usager.ref.present?
        interv = Intervenant.find_or_create_by(nom: @usager.ref.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-'))
        interv.ref = true
        interv.save
      end
      if @usager.pqi
        @usager.pqi_histo = ""
        @usager.pqi_histo << Date.today.strftime("%d/%m/%y")
        @usager.save
      end
      flash[:success] = "Nouvel usager ajouté !"
      unless current_user.benev?
        redirect_to id_edit_comp_path(id: @usager.id)
      else
        redirect_to id_rencontre_path(id: @usager.id)
      end
    else
      if params[:add_inconnu]
        flash[:danger] = "Renseignez la ville où se trouve l'usager inconnu."
        redirect_to new_usager_path
      else
        flash[:danger] = "Ajoutez au moins le nom ou le prénom de l'usager ! Si ils ne sont pas connus, spécifiez 'Inconnu' pour le nom. Il faut également renseigner son sexe et sa ville."
        redirect_to new_usager_path
      end
    end
  end

  def edit
    delete_groupe
    session[:stored] = "edit"
    @villes = [["Ville inconnue"], ["Autre (hors 93)"]]
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
  	@usager = Usager.find(params[:id])
  end

  def update
  	@usager = Usager.find(params[:id])
    stored_pqi = @usager.pqi
    if @usager.update_attribute(:pqi, params[:usager][:pqi]) && session[:stored] == "edit" && @usager.pqi != stored_pqi
      if @usager.update_attributes(usager_params)
        if @usager.pqi
          if @usager.pqi_histo
            @usager.pqi_histo << " ///// "
          else
            @usager.pqi_histo = ""
          end
        else
          @usager.pqi_histo << " - " unless @usager.pqi_histo.nil?
        end
        arr = @usager.pqi_histo.split(' ///// ')
        if arr.last == "#{Date.today.strftime("%d/%m/%y")} - "
          if arr.length >= 2
            @usager.pqi_histo = arr[0..(arr.length-2)].join(' ///// ')
          else
            @usager.pqi_histo = nil
          end
        else
          @usager.pqi_histo << Date.today.strftime("%d/%m/%y") unless @usager.pqi_histo.nil?
        end
        @usager.update_attributes(usager_params)
        if @usager.update_attribute(:ref, params[:usager][:ref])
          interv = Intervenant.find_or_create_by(nom: @usager.ref.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-'))
          interv.ref = true
          interv.save
        end
        if params[:usager][:groupe_nom] == ""
          @usager.update_attribute(:groupe_id, nil)
        end
        prenoms = ["Inconnu", "Inconnue", "Inconnu(e)"]
        noms = ["INCONNU", "INCONNUE", "INCONNU(E)"]
        @usager.update_attributes(prenom: "Inconnu", nom: "") if @usager.sexe == "Mr" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
        @usager.update_attributes(prenom: "Inconnue", nom: "") if @usager.sexe == "Mme" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
        @usager.update_attributes(prenom: "Inconnu(e)", nom: "") if @usager.sexe == "" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
        flash[:success] = "Usager édité"
        redirect_to @usager
      else
        flash[:danger] = "Mise à jour impossible. Veillez à remplir les informations nécessaires (Nom et/ou prénom, ville et sexe)."
        @usager.update_attribute(:pqi, stored_pqi)
        render 'edit'
      end
    elsif session[:stored] == "fiche"
      @usager.update_attribute(:fiche, params[:usager][:fiche])
      @usager.update_attribute(:pqi, stored_pqi)
      flash[:success] = "Fiche de rencontres usager éditée"
      redirect_to @usager
    elsif session[:stored] == "fiche_jour"
      @usager.update_attribute(:fiche_jour, params[:usager][:fiche_jour])
      @usager.update_attribute(:pqi, stored_pqi)
      flash[:success] = "Fiche de suivi jour usager éditée"
      redirect_to @usager
    elsif @usager.update_attributes(usager_params)
      if @usager.update_attribute(:ref, params[:usager][:ref])
        interv = Intervenant.find_or_create_by(nom: @usager.ref.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-'))
        interv.ref = true
        interv.save
      end
      if params[:usager][:groupe_nom] == ""
        @usager.update_attribute(:groupe_id, nil)
      end
      prenoms = ["Inconnu", "Inconnue", "Inconnu(e)"]
      noms = ["INCONNU", "INCONNUE", "INCONNU(E)"]
      @usager.update_attributes(prenom: "Inconnu", nom: "") if @usager.sexe == "Mr" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
      @usager.update_attributes(prenom: "Inconnue", nom: "") if @usager.sexe == "Mme" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
      @usager.update_attributes(prenom: "Inconnu(e)", nom: "") if @usager.sexe == "" && (prenoms.include?(@usager.prenom) || noms.include?(@usager.nom))
      flash[:success] = "Usager édité"
      redirect_to @usager
    else
      flash[:danger] = "Mise à jour impossible. Veillez à remplir les informations nécessaires (Nom et/ou prénom, ville et sexe)."
      render 'edit'
    end
  end

  def destroy
  	Usager.find(params[:id]).destroy
  	flash[:success] = "Usager supprimé"
  	redirect_to usagers_url
  end

  def pqi
    delete_groupe
    store_ville
    @villes = []
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    @usagers = Usager.where(pqi: true, ville: session[:stored_ville]).order('adresse ASC, adresse_précis ASC, nom ASC') unless session[:stored_ville] == "pqi"
    @ville_actuelle = session[:stored_ville]
    session.delete(:stored_ville)
  end

  def fiche
    delete_groupe
    store_last
    store_id
    @usager = Usager.find(session[:stored_id])
    session.delete(:stored_id)
  end

  def fiche_jour
    delete_groupe
    store_last
    store_id
    @usager = Usager.find(session[:stored_id])
    session.delete(:stored_id)
  end

  def edit_comp
    delete_groupe
    store_id
    session[:stored] = "edit_comp"
    @usager = Usager.find(session[:stored_id])
    @ressources = [ ["Salaire", "Salaire"],
                    ["Retraite", "Retraite"],
                    ["RSA", "RSA"],
                    ["AAH", "AAH"],
                    ["Prestation(s) familiale(s)", "Prestation(s) familiale(s)"],
                    ["ATA", "ATA"],
                    ["ASS", "ASS"],
                    ["ARE", "ARE"],
                    ["Rémunération de formation", "Rémunération de formation"],
                    ["Pension d'invalidité", "Pension d'invalidité"],
                    ["Autre", "Autre"],
                    ["Sans ressources", "Sans ressources"]]
    @prestas_med = [["CMU", "CMU"],
                    ["CMUC", "CMUC"],
                    ["AME", "AME"],
                	["Régime général", "Régime général"]]
    session.delete(:stored_id)
  end

  def post_comp
    store_id
    ressources = params[:usager][:ressources].reject{ |a| a == '0' }.join("\n")
    prestas_med = params[:usager][:prestas_med].reject{ |a| a == '0' }.join("\n")
    @usager = Usager.find(session[:stored_id])
    if @usager.update_attributes(ressources: ressources, prestas_med: prestas_med) && @usager.update_attributes(comp_params)
      flash[:success] = "Informations complémentaires éditées"
      if Usager.maximum("id") == @usager.id
        redirect_to id_rencontre_path(id: @usager.id)
      else
        redirect_to @usager
      end
    else
      flash[:danger] = "Problème inconnu, veuillez réessayer"
      redirect_to id_edit_comp_path(id: @usager.id)
    end
    session.delete(:stored_id)
  end

  private
    def usager_params
      params.require(:usager).permit( :nom,
                                      :prenom,
                                      :sexe,
                                      :ville,
                                      :adresse,
                                      :adresse_précis,
                                      :date_naissance,
                                      :tel,
                                      :notes,
                                      :pqi,
                                      :pqi_histo,
                                      :fiche,
                                      :groupe_nom,
                                      :ressources,
                                      :montant,
                                      :ref,
                                      :dmde,
                                      :date_dmde,
                                      :vu,
                                      enfants_attributes: [ :id,
                                                            :nom,
                                                            :prenom,
                                                            :sexe,
                                                            :date_naissance,
                                                            :_destroy ])
    end

    def comp_params
      params.require(:usager).permit( :montant,
                                      :dom,
                                      :dom_org,
                                      :dom_adr,
                                      :tut,
                                      :cur,
                                      :tutcur_org,
                                      :suivi,
                                      :suivi_org,
                                      :sejour,
                                      :cfr,
                                      :carte_date,
                                      :medecin,
                                      :medecin_infos,
                                      :pb_sante,
                                      :mobil,
                                      :infos_sante,
                                      :autres_infos)
    end
end