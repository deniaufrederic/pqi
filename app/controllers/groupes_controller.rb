class GroupesController < ApplicationController
  def show
  	@groupe = Groupe.find(params[:id])
  	@usagers = @groupe.usagers
  end
end
