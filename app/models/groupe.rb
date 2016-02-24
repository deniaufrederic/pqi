class Groupe < ActiveRecord::Base
  has_many :usagers

  before_save { self.nom = nom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }

  validates :nom, presence: true, uniqueness: true

  	def self.search(search)
      if search
        if Rails.env.production?
          where("nom ILIKE ?", "%#{search}%") 
        else
          where("nom LIKE ?", "%#{search}%")
        end
      else
        scoped
      end
    end
end
