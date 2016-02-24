class MaraudesController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :index, :show, :villes, :post_villes, :destroy]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:new, :create, :villes, :post_villes, :destroy]

  def index
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    if params[:search]
      @maraudes = Maraude.search(params[:search]).paginate(page: params[:page], per_page: 5)
      if @maraudes.empty?
        @maraudes = Maraude.search(params[:search].split('/').reverse.join('-')).paginate(page: params[:page], per_page: 10)
      end
    else
      @maraudes = Maraude.paginate(page: params[:page], per_page: 5)
    end
  end

  def show
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@maraude = Maraude.find(params[:id])
  end

  def new
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    @maraude = Maraude.new
    @types =  [ ["Maraude salariés 1", "Maraude salariés 1"],
                ["Maraude salariés 2", "Maraude salariés 2"],
                ["Maraude bénévoles", "Maraude bénévoles"],
                ["Maraude jour", "Maraude jour"],
                ["Maraude médicale", "Maraude médicale"]]
  end

  def create
    @maraude = Maraude.new(maraude_params)
    @maraude.villes = ""
    if Maraude.find_by(date: params[:maraude][:date].to_date.strftime("%F"), type_maraude: params[:maraude][:type_maraude])
      flash[:danger] = "Cette maraude existe déjà"
      redirect_to new_maraude_path
    elsif @maraude.save
      @maraude.date = params[:maraude][:date].to_date.strftime("%F")
      @maraude.save
      flash[:success] = "Maraude créée"
      redirect_to id_m_villes_path(id: @maraude.id)
    else  
      flash[:danger] = "Renseignez la date et le type de la maraude"
      redirect_to new_maraude_path
    end
  end

  def villes
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    store_id
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
    @maraude = Maraude.find(session[:stored_id])
    session.delete(:stored_id)
  end

  def post_villes
    store_id
    villes = params[:maraude][:villes].reject{ |a| a == '0' }.join("\n")
    @maraude = Maraude.find(session[:stored_id])
    if @maraude.update_attribute(:villes, villes)
      if params[:maraude][:intervenants_attributes]
        @maraude.update_attribute(:intervenants_attributes, params[:maraude][:intervenants_attributes])
      end
      flash[:success] = "Modifications apportées"
      redirect_to @maraude
    else
      flash[:danger] = "Problème inconnu, veuillez réessayer"
      redirect_to id_m_villes_path(id: @maraude.id)
    end
    session.delete(:stored_id)
  end

  def destroy
    Maraude.find(params[:id]).destroy
    flash[:success] = "Maraude supprimée"
    redirect_to maraudes_path
  end

  private

    def maraude_params
      params.require(:maraude).permit(:date,
                                      :type_maraude,
                                      :villes,
                                      intervenants_attributes: [:nom,
                                                                :ref,
                                                                :_destroy])
    end
end