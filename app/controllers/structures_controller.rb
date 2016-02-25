class StructuresController < ApplicationController
  before_action :logged_in_user,  only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:new, :create, :edit, :update, :destroy]

  def index
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
      session.delete(:ville)
    end
    if params[:search]
      @structures = Structure.search(params[:search]).order('nom ASC').paginate(page: params[:page], per_page: 20)
    else
      @structures = Structure.order('nom ASC').paginate(page: params[:page], per_page: 20)
    end
  end

  def show
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
      session.delete(:ville)
    end
    @structure = Structure.find(params[:id])
    @sigs = Rencontre.where(signale: true, sig_structure: @structure.nom)
    @accomps = Rencontre.where(accomp: true, accomp_structure: @structure.nom)
  end

  def new
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
                ["Villetaneuse", "Villetaneuse"],
                ["Autre (hors 93)", "Autre (hors 93)"]]
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
      session.delete(:ville)
    end
    @structure = Structure.new
  end

  def create
    @structure = Structure.new(structure_params)
    if @structure.save
      flash[:success] = "Structure créée"
      redirect_to @structure
    else
      render 'new'
    end
  end

  def edit
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
                ["Villetaneuse", "Villetaneuse"],
                ["Autre (hors 93)", "Autre (hors 93)"]]
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
      session.delete(:ville)
    end
    @structure = Structure.find(params[:id])
  end

  def update
    @structure = Structure.find(params[:id])
    if @structure.update_attributes(structure_params)
      flash[:success] = "Structure éditée"
      redirect_to @structure
    else
      if params[:structure][:nom].empty?
        flash[:danger] = "Renseignez le nom de la structure"
      else
        flash[:danger] = "Problème rencontré : veuillez réessayer"
      end
      redirect_to edit_structure_path(@structure)
    end
  end

  def destroy
    Structure.find(params[:id]).destroy
    flash[:success] = "Structure supprimée"
    redirect_to structures_path
  end


  private
    def structure_params
      params.require(:structure).permit(:nom,
                                        :ville,
                                        :adresse)
    end
end