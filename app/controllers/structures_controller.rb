class StructuresController < ApplicationController
  before_action :logged_in_user,  only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:new, :create, :edit, :update, :destroy]

  def index
    delete_groupe
    if params[:search]
      @structures = Structure.search(params[:search]).order('nom ASC').paginate(page: params[:page], per_page: 20)
    else
      @structures = Structure.order('nom ASC').paginate(page: params[:page], per_page: 20)
    end
  end

  def show
    delete_groupe
    @structure = Structure.find(params[:id])
    if params[:search]
      @sigs = Rencontre.where(signale: true, sig_structure: @structure.nom).search(params[:search]).order('date DESC')
      @accomps = Rencontre.where(accomp: true, accomp_structure: @structure.nom).search(params[:search]).order('date DESC')
    else
      @sigs = Rencontre.where(signale: true, sig_structure: @structure.nom).order('date DESC')
      @accomps = Rencontre.where(accomp: true, accomp_structure: @structure.nom).order('date DESC')
    end
  end

  def new
    @villes = []
    Ville.all.order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    delete_groupe
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
    @villes = []
    Ville.all.order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    delete_groupe
    @structure = Structure.find(params[:id])
  end

  def update
    @structure = Structure.find(params[:id])
    nom = @structure.nom
    @sigs = Rencontre.where(signale: true, sig_structure: @structure.nom)
    @accomps = Rencontre.where(accomp: true, accomp_structure: @structure.nom)
    if @structure.update_attributes(structure_params)
      if @structure.nom != nom
        if @sigs.present?
          @sigs.each do |s|
            s.update_attribute(:sig_structure, @structure.nom)
          end
        end
        if @accomps.present?
          @accomps.each do |a|
            a.update_attribute(:accomp_structure, @structure.nom)
          end
        end
      end
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