class MaraudesController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :index, :show, :villes, :post_villes, :destroy]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:new, :create, :villes, :post_villes, :destroy]

  def index
    delete_groupe
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
    delete_groupe
  	@maraude = Maraude.find(params[:id])
  end

  def new
    delete_groupe
    @maraude = Maraude.new
    @types = []
    TypeRenc.where(mar: true).each do |t|
      @types << ["#{t.nom}"]
    end
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
    delete_groupe
    store_id
    @villes = []
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
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