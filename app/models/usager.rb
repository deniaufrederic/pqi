class Usager < ActiveRecord::Base
  before_save { nom.upcase! }
  before_save { self.prenom = prenom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }
  default_scope -> { order(pqi: :desc, nom: :asc) }
  validate :at_least_one
  VALID_TEL_REGEX = /\A\d{10}\Z/
  VALID_ADR_REGEX = /\A\d+\s[a-zA-Z]+\s.+\Z/
  validates :tel, length: {is: 10}, format: {with: VALID_TEL_REGEX}, allow_blank: true
  validates :adresse, format: {with: VALID_ADR_REGEX}, allow_blank: true
  validates :user_id, presence: true
  validates :sexe, presence: true
  validates :ville, presence: true

    def self.search(search)
      if search
        if Rails.env.production?
          where("nom ILIKE ? OR ville ILIKE? OR prenom ILIKE? OR adresse ILIKE? OR adresse_précis ILIKE? OR sexe ILIKE? OR rencontres ILIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%") 
        else
          where("nom LIKE ? OR ville LIKE? OR prenom LIKE? OR adresse LIKE? OR adresse_précis LIKE? OR sexe LIKE? OR rencontres LIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
        end
      else
        scoped
      end
    end

  private

  	def at_least_one
  	  if self.prenom.blank? && self.nom.blank?
  	    self.errors.add(:base, "Please fill at least the name or surname")
  	  end
    end
end