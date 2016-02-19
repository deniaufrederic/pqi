class UsagersController < ApplicationController
  before_action :logged_in_user,  only: [:new, :show, :index, :create, :edit, :update, :destroy, :pqi, :fiche, :fiche_jour, :edit_comp, :post_comp]
  before_action :admin_user,      only: :destroy

  def new
    session[:stored] = "new"
    @usager = Usager.new
    @villes = [ ["Aubervilliers", "Aubervilliers"],
                ["Aulnay-sous-Bois", "Aulnay-sous-Bois"],
                ["Bagnolet", "Bagnolet"],
                ["Bobigny", "Bobigny"],
                ["Bondy", "Bondy"],
                ["Clichy-sous-Bois", "Clichy-sous-Bois"],
                ["Coubron", "Coubron"],
                ["Drancy", "Drancy"],
                ["Dugny", "Dugny"],
                ["Epinay-sur-Seine", "Epinay-sur-Seine"],
                ["Gagny", "Gagny"],
                ["Gournay-sur-Marne", "Gournay-sur-Marne"],
                ["L'Ile-Saint-Denis", "L'Ile-Saint-Denis"],
                ["La Courneuve", "La Courneuve"],
                ["La Plaine Saint-Denis", "La Plaine Saint-Denis"],
                ["Le Blanc-Mesnil", "Le Blanc-Mesnil"],
                ["Le Bourget", "Le Bourget"],
                ["Le Pré-Saint-Gervais", "Le Pré-Saint-Gervais"],
                ["Le Raincy", "Le Raincy"],
                ["Les Lilas", "Les Lilas"],
                ["Les Pavillons-sous-Bois", "Les Pavillons-sous-Bois"],
                ["Livry-Gargan", "Livry-Gargan"],
                ["Montfermeil", "Montfermeil"],
                ["Montreuil", "Montreuil"],
                ["Neuilly-Plaisance", "Neuilly-Plaisance"],
                ["Neuilly-sur-Marne", "Neuilly-sur-Marne"],
                ["Noisy-le-Grand", "Noisy-le-Grand"],
                ["Noisy-le-Sec", "Noisy-le-Sec"],
                ["Pantin", "Pantin"],
                ["Pierrefitte", "Pierrefitte"],
                ["Romainville", "Romainville"],
                ["Rosny-sous-Bois", "Rosny-sous-Bois"],
                ["Saint-Denis", "Saint-Denis"],
                ["Saint-Ouen", "Saint-Ouen"],
                ["Sevran", "Sevran"],
                ["Stains", "Stains"],
                ["Tremblay-en-France", "Tremblay-en-France"],
                ["Vaujours", "Vaujours"],
                ["Villemomble", "Villemomble"],
                ["Villepinte", "Villepinte"],
                ["Villetaneuse", "Villetaneuse"]]
  end

  def index
    if params[:search]
      @usagers = Usager.search(params[:search]).paginate(page: params[:page], per_page: 50)
    else
      @usagers = Usager.paginate(page: params[:page], per_page: 50)
    end
  end

  def show
  	@usager = Usager.find(params[:id])
  end

  def create
    @usager = Usager.new(usager_params)
    @usager.user_id = current_user.id
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
      if @usager.pqi
        @usager.pqi_histo = ""
        @usager.pqi_histo << Date.today.strftime("%d/%m/%y")
        @usager.save
      end
      flash[:success] = "Nouvel usager ajouté !"
      redirect_to id_edit_comp_path(id: @usager.id)
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
    session[:stored] = "edit"
    @villes = [ ["Aubervilliers", "Aubervilliers"],
                ["Aulnay-sous-Bois", "Aulnay-sous-Bois"],
                ["Bagnolet", "Bagnolet"],
                ["Bobigny", "Bobigny"],
                ["Bondy", "Bondy"],
                ["Clichy-sous-Bois", "Clichy-sous-Bois"],
                ["Coubron", "Coubron"],
                ["Drancy", "Drancy"],
                ["Dugny", "Dugny"],
                ["Epinay-sur-Seine", "Epinay-sur-Seine"],
                ["Gagny", "Gagny"],
                ["Gournay-sur-Marne", "Gournay-sur-Marne"],
                ["L'Ile-Saint-Denis", "L'Ile-Saint-Denis"],
                ["La Courneuve", "La Courneuve"],
                ["La Plaine Saint-Denis", "La Plaine Saint-Denis"],
                ["Le Blanc-Mesnil", "Le Blanc-Mesnil"],
                ["Le Bourget", "Le Bourget"],
                ["Le Pré-Saint-Gervais", "Le Pré-Saint-Gervais"],
                ["Le Raincy", "Le Raincy"],
                ["Les Lilas", "Les Lilas"],
                ["Les Pavillons-sous-Bois", "Les Pavillons-sous-Bois"],
                ["Livry-Gargan", "Livry-Gargan"],
                ["Montfermeil", "Montfermeil"],
                ["Montreuil", "Montreuil"],
                ["Neuilly-Plaisance", "Neuilly-Plaisance"],
                ["Neuilly-sur-Marne", "Neuilly-sur-Marne"],
                ["Noisy-le-Grand", "Noisy-le-Grand"],
                ["Noisy-le-Sec", "Noisy-le-Sec"],
                ["Pantin", "Pantin"],
                ["Pierrefitte", "Pierrefitte"],
                ["Romainville", "Romainville"],
                ["Rosny-sous-Bois", "Rosny-sous-Bois"],
                ["Saint-Denis", "Saint-Denis"],
                ["Saint-Ouen", "Saint-Ouen"],
                ["Sevran", "Sevran"],
                ["Stains", "Stains"],
                ["Tremblay-en-France", "Tremblay-en-France"],
                ["Vaujours", "Vaujours"],
                ["Villemomble", "Villemomble"],
                ["Villepinte", "Villepinte"],
                ["Villetaneuse", "Villetaneuse"]]
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
        if params[:usager][:groupe_nom] == ""
          @usager.update_attribute(:groupe_id, nil)
        end
        @usager.update_attribute(:prenom, "Inconnu") if @usager.sexe == "Mr"
        @usager.update_attribute(:prenom, "Inconnue") if @usager.sexe == "Mme"
        @usager.update_attribute(:prenom, "Inconnu(e)") if @usager.sexe == ""
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
      if params[:usager][:groupe_nom] == ""
        @usager.update_attribute(:groupe_id, nil)
      end
      @usager.update_attribute(:prenom, "Inconnu") if @usager.sexe == "Mr"
      @usager.update_attribute(:prenom, "Inconnue") if @usager.sexe == "Mme"
      @usager.update_attribute(:prenom, "Inconnu(e)") if @usager.sexe == ""
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
    store_ville
    @villes = [ ["Aubervilliers", "Aubervilliers"],
                ["Aulnay-sous-Bois", "Aulnay-sous-Bois"],
                ["Bagnolet", "Bagnolet"],
                ["Bobigny", "Bobigny"],
                ["Bondy", "Bondy"],
                ["Clichy-sous-Bois", "Clichy-sous-Bois"],
                ["Coubron", "Coubron"],
                ["Drancy", "Drancy"],
                ["Dugny", "Dugny"],
                ["Epinay-sur-Seine", "Epinay-sur-Seine"],
                ["Gagny", "Gagny"],
                ["Gournay-sur-Marne", "Gournay-sur-Marne"],
                ["L'Ile-Saint-Denis", "L'Ile-Saint-Denis"],
                ["La Courneuve", "La Courneuve"],
                ["La Plaine Saint-Denis", "La Plaine Saint-Denis"],
                ["Le Blanc-Mesnil", "Le Blanc-Mesnil"],
                ["Le Bourget", "Le Bourget"],
                ["Le Pré-Saint-Gervais", "Le Pré-Saint-Gervais"],
                ["Le Raincy", "Le Raincy"],
                ["Les Lilas", "Les Lilas"],
                ["Les Pavillons-sous-Bois", "Les Pavillons-sous-Bois"],
                ["Livry-Gargan", "Livry-Gargan"],
                ["Montfermeil", "Montfermeil"],
                ["Montreuil", "Montreuil"],
                ["Neuilly-Plaisance", "Neuilly-Plaisance"],
                ["Neuilly-sur-Marne", "Neuilly-sur-Marne"],
                ["Noisy-le-Grand", "Noisy-le-Grand"],
                ["Noisy-le-Sec", "Noisy-le-Sec"],
                ["Pantin", "Pantin"],
                ["Pierrefitte", "Pierrefitte"],
                ["Romainville", "Romainville"],
                ["Rosny-sous-Bois", "Rosny-sous-Bois"],
                ["Saint-Denis", "Saint-Denis"],
                ["Saint-Ouen", "Saint-Ouen"],
                ["Sevran", "Sevran"],
                ["Stains", "Stains"],
                ["Tremblay-en-France", "Tremblay-en-France"],
                ["Vaujours", "Vaujours"],
                ["Villemomble", "Villemomble"],
                ["Villepinte", "Villepinte"],
                ["Villetaneuse", "Villetaneuse"]]
    @usagers = Usager.where(pqi: true, ville: session[:stored_ville]) unless session[:stored_ville] == "pqi"
    @ville_actuelle = session[:stored_ville]
    session.delete(:stored_ville)
  end

  def fiche
    store_last
    store_id
    @usager = Usager.find(session[:stored_id])
    session.delete(:stored_id)
  end

  def fiche_jour
    store_last
    store_id
    @usager = Usager.find(session[:stored_id])
    session.delete(:stored_id)
  end

  def edit_comp
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
                    ["AME", "AME"]]
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
                                      :infos_sante,
                                      :autres_infos)
    end
end