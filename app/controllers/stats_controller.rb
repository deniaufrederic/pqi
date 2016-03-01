class StatsController < ApplicationController
  before_action :logged_in_user, 	only: [:show, :create]
  before_action :benev_user,      only: [:show, :create]

  def show
    delete_groupe
  	@ville = nil
  	@dates = nil
  	stats_ville
  	stats_dates
  	@villes = []
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    @ville = session[:stored_ville] unless session[:stored_ville].nil?
    @dates = session[:stored_dates] unless session[:stored_dates].nil?
    session.delete(:stored_ville)
    session.delete(:stored_dates)
  end

  def create
    if !params[:stat][:date_deb].present? && !params[:stat][:date_fin].present?
      flash[:danger] = "Veuillez indiquer une période !"
      redirect_to stats_path
  	elsif !params[:stat][:date_deb].present? && params[:stat][:date_fin].present?
  	  flash[:danger] = "Veuillez indiquer une date de début de période !"
  	  redirect_to stats_path
  	elsif params[:stat][:date_deb].present? && !params[:stat][:date_fin].present?
  	  flash[:danger] = "Veuillez indiquer une date de fin de période !"
  	  redirect_to stats_path
  	elsif !params[:stat][:date_deb].present? && params[:stat][:ville].present?
  	  flash[:danger] = "Veuillez indiquer une période !"
  	  redirect_to stats_path
    elsif !params[:stat][:date_fin].present? && params[:stat][:ville].present?
      flash[:danger] = "Veuillez indiquer une période !"
      redirect_to stats_path
  	elsif params[:stat][:ville].empty? && !params[:stat][:date_deb].empty?
  	  redirect_to stats_dates_path(	date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
  									date_fin: params[:stat][:date_fin].to_date.strftime("%F"))
  	else
  	  redirect_to stats_dates_ville_path(	date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
  											date_fin: params[:stat][:date_fin].to_date.strftime("%F"),
  											ville: params[:stat][:ville])
  	end
  end
end