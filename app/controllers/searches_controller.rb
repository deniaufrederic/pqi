class SearchesController < ApplicationController
  def new
  	@search = Search.new
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
  end

  def create
  	@search = Search.new(search_params)
    @search.date_naissance = params[:search][:date_naissance].to_s
    @search.save
  	redirect_to @search
  end

  def show
  	@search = Search.find(params[:id])
  end

  private

    def search_params
      params.require(:search).permit( :nom,
                                      :prenom,
                                      :ville,
                                      :adresse,
                                      :adresse_précis,
                                      :sexe,
                                      :date_naissance,
                                      :tel,
                                      :groupe_nom)
    end
end
