class GroupesController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]

  def index
  	@groupes = Groupe.paginate(page: params[:page], per_page: 20)
  end

  def show
  	@groupe = Groupe.find(params[:id])
  	@usagers = @groupe.usagers
  end
end
