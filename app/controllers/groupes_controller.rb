class GroupesController < ApplicationController
  before_action :logged_in_user,  only: [:index, :show, :edit, :update, :destroy]
  before_action :admin_user,      only: :destroy
  before_action :benev_user,      only: [:edit, :update, :destroy]

  def index
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
    if params[:search]
      @groupes = Groupe.search(params[:search]).order('nom ASC').paginate(page: params[:page], per_page: 20)
    else
      @groupes = Groupe.order('nom ASC').paginate(page: params[:page], per_page: 20)
    end
  end

  def show
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@groupe = Groupe.find(params[:id])
  	@usagers = @groupe.usagers
  end

  def edit
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@groupe = Groupe.find(params[:id])
  end

  def update
  	@groupe = Groupe.find(params[:id])
  	if @groupe.update_attributes(groupe_params)
  		flash[:success] = "Nom de groupe édité"
  		redirect_to @groupe
  	else
  		flash[:danger] = "Nom de groupe incorrect ou déjà utilisé"
  		redirect_to edit_groupe_path(@groupe)
  	end
  end

  def destroy
  	Groupe.find(params[:id]).destroy
  	flash[:success] = "Groupe supprimé"
  	redirect_to usagers_path
  end


  private
  	def groupe_params
  		params.require(:groupe).permit(:nom)
  	end
end
