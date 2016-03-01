class StatsController < ApplicationController
  before_action :logged_in_user, 	only: [:show, :create]
  before_action :benev_user,      only: [:show, :create]

  def show
    delete_groupe
  	@ville = nil
  	@dates = nil
  	stats_store
  	@villes = []
    Ville.where(ville_93: true).order('nom ASC').each do |v|
      @villes << ["#{v.nom}"]
    end
    @types = ["Maraude salariés (toutes)"]
    TypeRenc.all.each do |t|
      @types << ["#{t.nom}"]
    end
    @ville = session[:stored_ville] if session[:stored_ville].present?
    @dates = session[:stored_dates] if session[:stored_dates].present?
    @type = session[:stored_type] if session[:stored_type].present?
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
  	elsif params[:stat][:ville].empty? && params[:stat][:type].empty?
  	  redirect_to stats_dates_path(	date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
  									date_fin: params[:stat][:date_fin].to_date.strftime("%F"))
  	elsif !params[:stat][:ville].empty? && params[:stat][:type].empty?
  	  redirect_to stats_dates_ville_path(	date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
  											                  date_fin: params[:stat][:date_fin].to_date.strftime("%F"),
  											                  ville: params[:stat][:ville])
    elsif params[:stat][:ville].empty? && !params[:stat][:type].empty?
      redirect_to stats_dates_type_path(date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
                                        date_fin: params[:stat][:date_fin].to_date.strftime("%F"),
                                        type: params[:stat][:type])
    elsif !params[:stat][:ville].empty? && !params[:stat][:type].empty?
      redirect_to stats_dates_type_ville_path(date_deb: params[:stat][:date_deb].to_date.strftime("%F"),
                                              date_fin: params[:stat][:date_fin].to_date.strftime("%F"),
                                              type: params[:stat][:type],
                                              ville: params[:stat][:ville])
  	end
  end
end