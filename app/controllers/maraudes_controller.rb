class MaraudesController < ApplicationController
  before_action :logged_in_user, only: :index

  def index
  	@maraudes = Maraude.all
  end

  def show
  	@maraude = Maraude.find(params[:id])
  end

  private

  	def logged_in_user
      unless logged_in?
        flash[:danger] = "Merci de vous connecter."
        redirect_to root_url
      end
    end
end