class Structure < ActiveRecord::Base
	has_and_belongs_to_many :usagers

	before_save { self.nom = nom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }

	validates :nom, presence: true, uniqueness: true

		def self.search(search)
      if search
        if Rails.env.production?
          where("nom ILIKE ? OR ville ILIKE ? OR adresse ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%") 
        else
          where("nom LIKE ? OR ville LIKE ? OR adresse LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
        end
      else
        scoped
      end
    end
end
