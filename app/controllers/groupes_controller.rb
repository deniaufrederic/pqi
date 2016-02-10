class GroupesController < ApplicationController
  before_action :logged_in_user, :show

  def show
  	@groupe = Groupe.find(params[:id])
  	@usagers = @groupe.usagers
  end
end
