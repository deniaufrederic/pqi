class Rencontre < ActiveRecord::Base
  belongs_to :usager

  default_scope -> { order(date: :desc) }

  validates :usager_id, presence: true,
  						uniqueness: { scope: [:date, :type_renc] }
  validates :date, presence: true
  validates :type_renc, presence: true
  validates :ville, presence: true

  	def self.search(search)
      if search
        if Rails.env.production?
          joins(:usager).where("to_char(rencontres.date, 'DD/MM/YYYY') ILIKE? OR rencontres.type_renc ILIKE? OR usagers.nom ILIKE? OR usagers.prenom ILIKE? OR usagers.sexe ILIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
        else
          joins(:usager).where("rencontres.date LIKE? OR rencontres.type_renc LIKE? OR usagers.nom LIKE? OR usagers.prenom LIKE? OR usagers.sexe LIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
        end
      else
        scoped
      end
    end
end
