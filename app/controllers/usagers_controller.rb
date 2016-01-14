class UsagersController < ApplicationController
  before_action :logged_in_user,  only: [:show, :index, :create, :edit, :update, :destroy, :pqi, :rencontre, :fiche]
  before_action :admin_user,      only: :destroy

  def new
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
      @usagers = Usager.search(params[:search]).paginate(page: params[:page], per_page: 10)
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
    if @usager.save
      if @usager.pqi
        @usager.pqi_histo = ""
        @usager.pqi_histo << Date.today.strftime("%d/%m/%y")
        @usager.save
      end
      flash[:success] = "Nouvel usager ajouté !"
      redirect_to id_rencontre_path(:id => @usager.id)
    else
      flash[:danger] = "Ajoutez au moins le nom ou le prénom de l'usager ! Si ils ne sont pas connus, spécifiez 'Inconnu' pour le nom. Il faut également renseigner son sexe et sa ville."
      redirect_to usagers_path
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
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
  	@usager = Usager.find(params[:id])
  end

  def update
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
    stored_pqi = @usager.pqi
    if @usager.update_attribute(:derniere, params[:usager][:derniere]) && session[:stored] == "rencontre"
      if @usager.derniere
        if Maraude.find_by(date: params[:usager][:derniere]).present?
          @maraude = Maraude.find_by(date: params[:usager][:derniere])
          @maraude.rencontres << "#{@usager.sexe} #{@usager.nom} #{@usager.prenom} (#{@usager.ville})\n"
        else
          @maraude = Maraude.new(date: params[:usager][:derniere], rencontres: "#{@usager.sexe} #{@usager.nom} #{@usager.prenom} (#{@usager.ville})\n", signalements: "", accompagnements: "")
        end
        @maraude.cr = "COMPTE-RENDU DE MARAUDE DU #{@usager.derniere}\n\n\n" unless @maraude.cr
        @maraude.cr << "- #{@usager.sexe} #{@usager.nom} #{@usager.prenom} : "
        rencontre_u = "// Rencontre du #{@usager.derniere.strftime("%d/%m/%y")} //"
        if @usager.update_attribute(:details, params[:usager][:details]) && @usager.details
          rencontre_u << "\n#{@usager.details}"
          @maraude.cr << "#{@usager.details}\n\n"
        else
          rencontre_u << "\nRencontre sans détails."
          @maraude.cr << "Rien de notable.\n\n"
        end
        rencontre_u << "\n\n\n" unless !@usager.fiche
        rencontre_u << "#{@usager.fiche}"
        @usager.fiche = rencontre_u
        @maraude.save
        if @usager.update_attribute(:signale, params[:usager][:signale]) && @usager.signale
          if !params[:usager][:signalement].empty?
            @usager.update_attribute(:signalement, params[:usager][:signalement])
            if @usager.dates_sig.nil?
              @usager.dates_sig = ""
            else
              @usager.dates_sig << " - "
            end
            @usager.dates_sig << @usager.derniere.strftime("%y/%m/%d")
            @usager.dates_sig << " (#{@usager.signalement})"
            @maraude.signalements << "#{@usager.sexe} #{@usager.nom} #{@usager.prenom} (#{@usager.signalement})\n"
            @maraude.save
          else
            flash[:danger] = "Précisez le type de signalement"
            redirect_to id_rencontre_path(:id => @usager.id)
          end
        else
          params[:usager][:signalement] = nil
        end
        if @usager.rencontres.nil?
          @usager.rencontres = ""
        else
          @usager.rencontres << " - "
        end
        @usager.rencontres << @usager.derniere.strftime("%y/%m/%d")
        arr = @usager.rencontres.split(" - ").sort
        @usager.rencontres = arr.join(' - ')
        if @usager.pqi && @usager.pqi_histo.nil?
          @usager.pqi_histo = ""
          @usager.pqi_histo << Date.today.strftime("%d/%m/%y")
        end
        if (@usager.signale && !params[:usager][:signalement].empty?) || !@usager.signale
          @usager.update_attributes(usager_params)
          flash[:success] = "Rencontre ajoutée avec #{@usager.sexe} #{@usager.nom} #{@usager.prenom}"
          redirect_to usagers_path
        end
      else
        flash[:danger] = "Renseignez une date"
        redirect_to id_rencontre_path(:id => @usager.id)
      end
    elsif @usager.update_attribute(:pqi, params[:usager][:pqi]) && session[:stored] == "edit" && @usager.pqi != stored_pqi
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
        @usager.pqi_histo << Date.today.strftime("%d/%m/%y") unless @usager.pqi_histo.nil?
        @usager.update_attributes(usager_params)
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
      flash[:success] = "Fiche de suivi usager éditée"
      redirect_to @usager
    elsif @usager.update_attributes(usager_params)
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

  def rencontre
    store_last
    store_id
    @signalements = [ ["Signalement 115", "Signalement 115"],
                      ["Signalement tiers", "Signalement tiers"],
                      ["Croisé(e) en maraude", "Croisé(e) en maraude"]]
    @usager = Usager.find_by(id: session[:stored_id])
    session.delete(:stored_id)
  end

  def fiche
    store_last
    store_id
    @usager = Usager.find_by(id: session[:stored_id])
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
                                      :derniere,
                                      :rencontres,
                                      :signalement,
                                      :signale,
                                      :dates_sig,
                                      :pqi_histo,
                                      :details,
                                      :fiche)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Merci de vous connecter."
        redirect_to root_url
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end