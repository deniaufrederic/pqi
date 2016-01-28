class Enfant < ActiveRecord::Base
  belongs_to :usager

  before_save { nom.upcase! }
  before_save { self.prenom = prenom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }

  validate :at_least_one
  
  private

  	def at_least_one
  	  if self.prenom.blank? && self.nom.blank?
  	    self.errors.add(:base, "Please fill at least the name or surname")
  	  end
    end
end
