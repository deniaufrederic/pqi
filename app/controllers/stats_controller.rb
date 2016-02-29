class StatsController < ApplicationController
  before_action :logged_in_user, 	only: [:show, :create]
  before_action :benev_user,      only: [:show, :create]

  def show
    delete_groupe
  	@ville = nil
  	@dates = nil
  	stats_ville
  	stats_dates
  	@villes = [ ["Aubervilliers", "Aubervilliers"],
                ["Aulnay-sous-Bois", "Aulnay-sous-Bois"],
                ["Bagnolet", "Bagnolet"],
                ["Bobigny", "Bobigny"],
                ["Bondy", "Bondy"],
                ["Clichy-sous-Bois", "Clichy-sous-Bois"],
                ["Coubron", "Coubron"],
                ["Drancy", "Drancy"],
                ["Dugny", "Dugny"],
                ["Epinay-sur-Seine", "Epinay-sur-Seine"],
                ["Gagny", "Gagny"],
                ["Gournay-sur-Marne", "Gournay-sur-Marne"],
                ["L'Ile-Saint-Denis", "L'Ile-Saint-Denis"],
                ["La Courneuve", "La Courneuve"],
                ["La Plaine Saint-Denis", "La Plaine Saint-Denis"],
                ["Le Blanc-Mesnil", "Le Blanc-Mesnil"],
                ["Le Bourget", "Le Bourget"],
                ["Le Pré-Saint-Gervais", "Le Pré-Saint-Gervais"],
                ["Le Raincy", "Le Raincy"],
                ["Les Lilas", "Les Lilas"],
                ["Les Pavillons-sous-Bois", "Les Pavillons-sous-Bois"],
                ["Livry-Gargan", "Livry-Gargan"],
                ["Montfermeil", "Montfermeil"],
                ["Montreuil", "Montreuil"],
                ["Neuilly-Plaisance", "Neuilly-Plaisance"],
                ["Neuilly-sur-Marne", "Neuilly-sur-Marne"],
                ["Noisy-le-Grand", "Noisy-le-Grand"],
                ["Noisy-le-Sec", "Noisy-le-Sec"],
                ["Pantin", "Pantin"],
                ["Pierrefitte", "Pierrefitte"],
                ["Romainville", "Romainville"],
                ["Rosny-sous-Bois", "Rosny-sous-Bois"],
                ["Saint-Denis", "Saint-Denis"],
                ["Saint-Ouen", "Saint-Ouen"],
                ["Sevran", "Sevran"],
                ["Stains", "Stains"],
                ["Tremblay-en-France", "Tremblay-en-France"],
                ["Vaujours", "Vaujours"],
                ["Villemomble", "Villemomble"],
                ["Villepinte", "Villepinte"],
                ["Villetaneuse", "Villetaneuse"]]
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