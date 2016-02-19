class Intervenant < ActiveRecord::Base
	has_and_belongs_to_many :maraudes

	before_save { self.nom = nom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }

	validates :nom, presence: true, uniqueness: true
end