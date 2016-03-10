class Usager < ActiveRecord::Base
  has_many :rencontres, :dependent => :destroy
  has_many :enfants, :dependent => :destroy
  belongs_to :groupe
  has_and_belongs_to_many :structures

  accepts_nested_attributes_for :enfants, reject_if: lambda { |a| a[:nom].blank? && a[:prenom].blank? },
                                          allow_destroy: true

  before_save { nom.upcase! }
  before_save { self.prenom = prenom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }

  default_scope -> { order(nom: :asc, prenom: :asc) }
  
  validate :at_least_one
  validates :user_id, presence: true
  validates :sexe, presence: true, allow_blank: true
  validates :ville, presence: true

  def groupe_nom
    groupe.try(:nom)
  end

  def groupe_nom=(nom)
    self.groupe = Groupe.find_or_create_by(nom: nom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-')) if nom.present?
  end

    def self.search(search)
      if search
        if Rails.env.production?
          where("usagers.nom ILIKE ? OR usagers.ville ILIKE? OR usagers.prenom ILIKE? OR usagers.adresse ILIKE? OR usagers.adresse_précis ILIKE? OR usagers.sexe ILIKE? OR to_char(usagers.date_naissance, 'DD/MM/YYYY') ILIKE? OR usagers.tel ILIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
        else
          where("nom LIKE ? OR ville LIKE? OR prenom LIKE? OR adresse LIKE? OR adresse_précis LIKE? OR sexe LIKE? OR date_naissance LIKE? OR tel LIKE?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
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