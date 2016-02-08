class Search < ActiveRecord::Base
  def usagers
  	@usagers ||= find_usagers
  end

  private

  	def find_usagers
  	  usagers = Usager.order(:ville, :nom)
  	  usagers = usagers.where("ville like ?", "%#{ville}%") if ville.present?
  	  usagers = usagers.where("nom like ?", "%#{nom}%") if nom.present?
  	  usagers = usagers.where("prenom like ?", "%#{prenom}%") if prenom.present?
  	  usagers = usagers.where("adresse like ?", "%#{adresse}%") if adresse.present?
  	  usagers = usagers.where("adresse_précis like ?", "%#{adresse_précis}%") if adresse_précis.present?
  	  usagers = usagers.where("sexe like ?", "%#{sexe}%") if sexe.present?
  	  usagers = usagers.where("date_naissance like ?", "%#{date_naissance}%") if date_naissance.present?
  	  usagers = usagers.where("tel like ?", "%#{tel}%") if tel.present?
  	  usagers = usagers.where("groupe_nom like ?", "%#{groupe_nom}%") if groupe_nom.present?
  	end
end
