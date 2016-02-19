class GroupesController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]

  def index
  	@groupes = Groupe.paginate(page: params[:page], per_page: 20)
  end

  def show
  	@groupe = Groupe.find(params[:id])
  	@usagers = @groupe.usagers
  end

  def edit
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
